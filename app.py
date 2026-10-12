from flask import Flask, render_template, request, redirect, url_for, session,jsonify

from config import get_db_connection
from dotenv import load_dotenv
import os

# Fix OpenBLAS memory issue
os.environ["OPENBLAS_NUM_THREADS"] = "1"
os.environ["OMP_NUM_THREADS"] = "1"

from datetime import datetime
from flask import jsonify

import joblib
import requests

load_dotenv()

model = joblib.load("ml/disaster_model.pkl")

app = Flask(__name__)
app.secret_key = "smart_disaster_secret_key"

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/risk-prediction', methods=['GET','POST'])
def risk_prediction():

    prediction = None

    if request.method == "POST":

        temperature = float(request.form['temperature'])
        humidity = float(request.form['humidity'])
        wind_speed = float(request.form['wind_speed'])

        # Convert rainfall level to number
        rainfall_level = request.form['rainfall']

        if rainfall_level == "Low":
            rainfall = 50

        elif rainfall_level == "Medium":
            rainfall = 150

        else:
            rainfall = 300


        pressure = float(request.form['pressure'])


        input_data = [[
            temperature,
            humidity,
            wind_speed,
            rainfall,
            pressure
        ]]


        result = model.predict(input_data)

        prediction = result[0]

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
        """
        INSERT INTO risk_predictions
        (
        district,
        disaster_type,
        rainfall,
        temperature,
        humidity,
        wind_speed,
        pressure,
        risk_level
        )
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
        """,
        (
        request.form['district'],
        request.form['disaster'],
        rainfall,
        temperature,
        humidity,
        wind_speed,
        pressure,
        str(prediction)
        )
        )

        conn.commit()
        print("Data inserted successfully")
        cursor.close()
        conn.close()

        print("Prediction Result:", prediction)


    return render_template(
        "risk_prediction.html",
        prediction=prediction,
        district=request.form.get("district"),
        disaster=request.form.get("disaster"),
        rainfall_level=request.form.get("rainfall"),
        river=request.form.get("river"),
        history=request.form.get("history")
    )


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        email = request.form.get("email")
        password = request.form.get("password")

        try:
            connection = get_db_connection()
            cursor = connection.cursor(dictionary=True)

            sql = """
                SELECT * FROM users
                WHERE email = %s AND password = %s
            """

            cursor.execute(sql, (email, password))
            user = cursor.fetchone()

            cursor.close()
            connection.close()

            if user:
                session['user_id'] = user['id']
                session['name'] = user['name']
                session['user_type'] = user['user_type']

                return render_template(
                    "dashboard.html",
                    user=user
                )

            return "Invalid email or password!"

        except Exception as e:
            return f"Login failed: {e}"

    return render_template("login.html")


@app.route("/register", methods=["GET", "POST"])
def register():

    if request.method == "POST":

        name = request.form.get("name")
        email = request.form.get("email")
        phone = request.form.get("phone")
        password = request.form.get("password")
        user_type = request.form.get("user_type")

        try:
            connection = get_db_connection()
            cursor = connection.cursor()

            sql = """
                INSERT INTO users
                (name, email, phone, password, user_type)
                VALUES (%s, %s, %s, %s, %s)
            """

            values = (
                name,
                email,
                phone,
                password,
                user_type
            )

            cursor.execute(sql, values)

            connection.commit()

            cursor.close()
            connection.close()

            return render_template("success.html")

        except Exception as e:

            return f"Registration failed: {e}"

    return render_template("register.html")


@app.route("/test-db")
def test_db():

    try:
        connection = get_db_connection()
        connection.close()

        return "MySQL Connected Successfully!"

    except Exception as e:
        return f"MySQL Connection Failed: {e}"


@app.route("/dashboard")
def dashboard():

    if "user_id" not in session:
        return redirect(url_for("login"))


    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)


    # User info
    cursor.execute("""
        SELECT name, user_type
        FROM users
        WHERE id = %s
    """, (session["user_id"],))

    user = cursor.fetchone()


    # Total contact messages count
    cursor.execute("""
        SELECT COUNT(*) AS total_messages
        FROM contact_messages
    """)

    message_data = cursor.fetchone()

    message_count = message_data["total_messages"]



    cursor.close()
    conn.close()



    if not user:
        return redirect(url_for("login"))



    return render_template(
        "dashboard.html",
        name=user["name"],
        user_type=user["user_type"],
        message_count=message_count
    )

@app.route('/google-map')
def google_map():
    return render_template('google_map.html')

@app.route('/admin/volunteers')
def admin_volunteers():

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT *
            FROM volunteers
            ORDER BY id DESC
        """)

        volunteers = cursor.fetchall()

        cursor.close()
        conn.close()

        return render_template(
            'manage_volunteers.html',
            volunteers=volunteers
        )

    except Exception as e:
        return f"Error loading volunteers: {e}"

@app.route('/admin/risk-predictions')
def admin_risk_predictions():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM risk_predictions
        ORDER BY created_at DESC
        """
    )

    predictions = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin_risk_predictions.html",
        predictions=predictions
    )



@app.route('/contact', methods=['GET', 'POST'])
def contact():

    if request.method == 'POST':

        name = request.form['name']
        email = request.form['email']
        subject = request.form['subject']
        message = request.form['message']

        print(name)
        print(message)

        try:
            conn = get_db_connection()
            cursor = conn.cursor()

            cursor.execute(
                """
                INSERT INTO contact_messages
                (name, email, subject, message)
                VALUES (%s, %s, %s, %s)
                """,
                (name, email, subject, message)
            )

            conn.commit()

            cursor.close()
            conn.close()

            return render_template(
                'contact.html',
                success="Message sent successfully!"
            )

        except Exception as e:
            return f"Error: {e}"


    return render_template('contact.html')

@app.route("/api/sos_requests")
def api_sos_requests():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
        id,
        message,
        location,
        status,
        latitude,
        longitude,
        created_at
        FROM sos_requests
        WHERE latitude IS NOT NULL
        AND longitude IS NOT NULL
    """)

    sos = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(sos)

@app.route('/admin/messages')
def admin_messages():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM contact_messages ORDER BY id DESC"
    )

    messages = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin_messages.html",
        messages=messages
    )


@app.route('/sos', methods=['GET', 'POST'])
def sos():

    if request.method == 'POST':

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO sos_requests
            (user_id, message, location, status)
            VALUES (%s, %s, %s, %s)
        """, (
            session.get('user_id'),
            'Emergency SOS Request',
            'Barishal',
            'Pending'
        ))

        conn.commit()

        cursor.close()
        conn.close()

        return render_template(
            'sos.html',
            success='SOS request sent successfully!'
        )

    return render_template('sos.html')
    
@app.route('/admin/sos')
def admin_sos():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            s.id,
            s.user_id,
            u.name,
            u.email,
            s.message,
            s.location,
            s.status,
            s.created_at
        FROM sos_requests s
        LEFT JOIN users u ON s.user_id = u.id
        ORDER BY s.id DESC
    """)

    sos_requests = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        'admin_sos.html',
        sos_requests=sos_requests
    )    
@app.route('/admin/sos/resolve/<int:sos_id>', methods=['POST'])
def resolve_sos(sos_id):

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT user_type
        FROM users
        WHERE id = %s
    """, (user_id,))

    user = cursor.fetchone()

    if not user or user['user_type'].lower() != 'admin':
        cursor.close()
        conn.close()
        return "Access Denied! Admin only.", 403

    cursor.execute("""
        UPDATE sos_requests
        SET status = 'Resolved'
        WHERE id = %s
    """, (sos_id,))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect('/admin/sos')

@app.route('/shelters')
def shelters():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    cursor.execute("SELECT * FROM shelters ORDER BY id DESC")
    shelters = cursor.fetchall()

    cursor.close()
    connection.close()

    return render_template('shelters.html', shelters=shelters)
@app.route('/map')
def map_page():
    return render_template('map.html')

@app.route("/alerts")
def alerts():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM alerts ORDER BY created_at DESC")
    alerts_data = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("alerts.html", alerts=alerts_data)

@app.route("/admin/add-alert", methods=["GET", "POST"])
def add_alert():

    if request.method == "POST":

        title = request.form.get("title")
        message = request.form.get("message")
        severity = request.form.get("severity")
        disaster_type = request.form.get("disaster_type")
        location = request.form.get("location")

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO alerts
            (title, message, severity, disaster_type, location)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            title,
            message,
            severity,
            disaster_type,
            location
        ))

        conn.commit()

        cursor.close()
        conn.close()

        return redirect("/alerts")

    return render_template("add_alert.html")


@app.route("/live-map")
def live_map():
    return render_template("live_map.html")




@app.route('/volunteer', methods=['GET', 'POST'])
def volunteer():

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':

        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        skill = request.form['skill']
        availability = request.form['availability']

        cursor.execute("""
            INSERT INTO volunteers
            (user_id, name, email, phone, skill, availability, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            user_id,
            name,
            email,
            phone,
            skill,
            availability,
            'Pending'
        ))

        conn.commit()

        cursor.close()
        conn.close()

        return redirect('/volunteer')

    cursor.execute("""
        SELECT *
        FROM volunteers
        WHERE user_id = %s
        ORDER BY id DESC
        LIMIT 1
    """, (user_id,))

    volunteer = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template(
        'volunteer.html',
        volunteer=volunteer
    )


@app.route('/admin/volunteers/approve/<int:volunteer_id>', methods=['POST'])
def approve_volunteer(volunteer_id):

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT user_type
        FROM users
        WHERE id = %s
    """, (user_id,))

    user = cursor.fetchone()

    if not user or user['user_type'].lower() != 'admin':
        cursor.close()
        conn.close()
        return "Access Denied! Admin only.", 403

    cursor.execute("""
        UPDATE volunteers
        SET status = 'Approved'
        WHERE id = %s
    """, (volunteer_id,))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect('/admin/volunteers')


@app.route('/admin/volunteers/reject/<int:volunteer_id>', methods=['POST'])
def reject_volunteer(volunteer_id):

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT user_type
        FROM users
        WHERE id = %s
    """, (user_id,))

    user = cursor.fetchone()

    if not user or user['user_type'].lower() != 'admin':
        cursor.close()
        conn.close()
        return "Access Denied! Admin only.", 403

    cursor.execute("""
        UPDATE volunteers
        SET status = 'Rejected'
        WHERE id = %s
    """, (volunteer_id,))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect('/admin/volunteers')


@app.route('/profile')
def profile():

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT id, name, email, phone, user_type FROM users WHERE id = %s",
        (user_id,)
    )

    user = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template('profile.html', user=user)

@app.route('/edit-profile', methods=['GET', 'POST'])
def edit_profile():

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':

        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']

        cursor.execute("""
            UPDATE users
            SET name = %s,
                email = %s,
                phone = %s
            WHERE id = %s
        """, (name, email, phone, user_id))

        conn.commit()

        cursor.close()
        conn.close()

        return redirect('/profile')

    cursor.execute(
        "SELECT id, name, email, phone, user_type FROM users WHERE id = %s",
        (user_id,)
    )

    user = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template('edit_profile.html', user=user)

@app.route('/change-password', methods=['GET', 'POST'])
def change_password():

    user_id = session.get('user_id')

    if not user_id:
        return redirect('/login')

    if request.method == 'POST':

        current_password = request.form['current_password']
        new_password = request.form['new_password']
        confirm_password = request.form['confirm_password']

        if new_password != confirm_password:
            return render_template(
                'change_password.html',
                error='New passwords do not match.'
            )

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute(
            "SELECT password FROM users WHERE id = %s",
            (user_id,)
        )

        user = cursor.fetchone()

        if not user or user['password'] != current_password:
            cursor.close()
            conn.close()

            return render_template(
                'change_password.html',
                error='Current password is incorrect.'
            )

        cursor.execute(
            "UPDATE users SET password = %s WHERE id = %s",
            (new_password, user_id)
        )

        conn.commit()

        cursor.close()
        conn.close()

        return render_template(
            'change_password.html',
            success='Password changed successfully!'
        )

    return render_template('change_password.html')




@app.route("/weather")
def weather():

    api_key = os.getenv("WEATHER_API_KEY")

    city = request.args.get("city", "Barishal").strip()

    if not city:
        city = "Barishal"

    # Bangladesh-এর কিছু শহরের common spelling ঠিক করা
    city_names = {
        "barishal": "Barisal",
        "chittagong": "Chattogram",
        "comilla": "Cumilla",
        "cox's bazar": "Cox's Bazar"
    }

    search_city = city_names.get(
        city.lower(),
        city
    )

    if not api_key:
        return render_template(
            "weather.html",
            city=city,
            error="Weather API key is missing. Please check your .env file."
        )

    # Current weather API
    current_url = "https://api.openweathermap.org/data/2.5/weather"

    # 5 day / 3 hour forecast API
    forecast_url = "https://api.openweathermap.org/data/2.5/forecast"

    params = {
        "q": f"{search_city},BD",
        "appid": api_key,
        "units": "metric"
    }

    try:

        # --------------------------------
        # CURRENT WEATHER
        # --------------------------------

        current_response = requests.get(
            current_url,
            params=params,
            timeout=10
        )

        if current_response.status_code == 404:

            return render_template(
                "weather.html",
                city=city,
                error="City not found. Please enter a valid Bangladesh city."
            )

        if current_response.status_code == 401:

            return render_template(
                "weather.html",
                city=city,
                error="Invalid Weather API key. Please check your .env file."
            )

        if current_response.status_code != 200:

            return render_template(
                "weather.html",
                city=city,
                error="Weather service is currently unavailable."
            )

        current_data = current_response.json()

        # Location
        city_name = current_data["name"]
        country = current_data["sys"]["country"]

        latitude = current_data["coord"]["lat"]
        longitude = current_data["coord"]["lon"]

        # Temperature
        temperature = round(
            current_data["main"]["temp"],
            1
        )

        feels_like = round(
            current_data["main"]["feels_like"],
            1
        )

        min_temperature = round(
            current_data["main"]["temp_min"],
            1
        )

        max_temperature = round(
            current_data["main"]["temp_max"],
            1
        )

        # Humidity
        humidity = current_data["main"]["humidity"]

        # Pressure
        pressure = current_data["main"]["pressure"]

        # Visibility
        visibility_data = current_data.get(
            "visibility",
            0
        )

        if visibility_data:
            visibility = round(
                visibility_data / 1000,
                1
            )
        else:
            visibility = "N/A"

        # Wind
        wind_data = current_data.get(
            "wind",
            {}
        )

        wind_speed = wind_data.get(
            "speed",
            0
        )


        wind_degree = wind_data.get(
            "deg",
            0
        )
        # --------------------------------
        # ML DISASTER RISK PREDICTION
        # --------------------------------

        rainfall = current_data.get(
          "rain",
          {}
        ).get(
           "1h",
            0
        )

        risk_prediction = model.predict([[
         temperature,
           humidity,
          wind_speed,
           rainfall,
           pressure
        ]])

        # Get prediction from ML model
        risk_level = str(risk_prediction[0]).strip().capitalize()

        print("ML RISK:", risk_level)

      


        # --------------------------------
        # AUTOMATIC DISASTER ALERT
        # --------------------------------

        if risk_level == "High":

            conn = get_db_connection()
            cursor = conn.cursor()

            cursor.execute("""
                SELECT id
                FROM alerts
                WHERE title = %s
                AND location = %s
                AND created_at >= NOW() - INTERVAL 30 MINUTE
            """, (
                "AI Disaster Risk Alert",
                city_name
            ))

            existing_alert = cursor.fetchone()

            if not existing_alert:

                cursor.execute("""
                    INSERT INTO alerts
                    (title, message, disaster_type, location, severity)
                    VALUES (%s, %s, %s, %s, %s)
                """, (
                    "AI Disaster Risk Alert",
                    f"Machine Learning detected a HIGH disaster risk in {city_name}. "
                    f"Current temperature is {temperature}°C, humidity is {humidity}%, "
                    f"wind speed is {wind_speed} m/s and rainfall is {rainfall} mm.",
                    "AI Risk",
                    city_name,
                    "HIGH"
                ))

                conn.commit()

            cursor.close()
            conn.close()

        # Weather condition
        weather_data = current_data["weather"][0]

        weather_condition = weather_data["description"]

        weather_icon = weather_data["icon"]

        # Day / Night
        if weather_icon.endswith("n"):
            day_night = "Night"
        else:
            day_night = "Day"

        # Sunrise
        sunrise = datetime.fromtimestamp(
            current_data["sys"]["sunrise"]
        ).strftime("%I:%M %p")

        # Sunset
        sunset = datetime.fromtimestamp(
            current_data["sys"]["sunset"]
        ).strftime("%I:%M %p")

        # Last updated
        updated = datetime.fromtimestamp(
            current_data["dt"]
        ).strftime("%d %B %Y, %I:%M %p")


        # --------------------------------
        # 5 DAY FORECAST
        # --------------------------------

        forecast_response = requests.get(
            forecast_url,
            params=params,
            timeout=10
        )

        forecast = []

        if forecast_response.status_code == 200:

            forecast_data = forecast_response.json()

            # API gives weather every 3 hours.
            # We select one suitable forecast
            # for each day.

            daily_data = {}

            for item in forecast_data.get("list", []):

                date_text = item["dt_txt"].split(" ")[0]

                if date_text not in daily_data:

                    daily_data[date_text] = item

            # Maximum 5 days
            for date_text, item in list(
                daily_data.items()
            )[:5]:

                forecast_date = datetime.strptime(
                    date_text,
                    "%Y-%m-%d"
                )

                forecast.append({

                    "date": forecast_date.strftime(
                        "%a, %d %b"
                    ),

                    "temperature": round(
                        item["main"]["temp"],
                        1
                    ),

                    "feels_like": round(
                        item["main"]["feels_like"],
                        1
                    ),

                    "humidity": item["main"]["humidity"],

                    "weather": item["weather"][0]["description"],

                    "icon": item["weather"][0]["icon"],

                    "wind": round(
                        item.get("wind", {}).get(
                            "speed",
                            0
                        ),
                        1
                    )
                })


        return render_template(
            "weather.html",

            # Location
            city=city_name,
            country=country,

            latitude=latitude,
            longitude=longitude,

            # Current weather
            temperature=temperature,
            feels_like=feels_like,

            min_temperature=min_temperature,
            max_temperature=max_temperature,

            humidity=humidity,
            pressure=pressure,
            rainfall=rainfall,
            risk_level=risk_level,

            visibility=visibility,

            wind_speed=wind_speed,
            wind_degree=wind_degree,

            weather=weather_condition,
            weather_icon=weather_icon,

            day_night=day_night,

            sunrise=sunrise,
            sunset=sunset,

            updated=updated,

            # Forecast
            forecast=forecast
        )


    except requests.Timeout:

        return render_template(
            "weather.html",
            city=city,
            error="Weather service is taking too long to respond. Please try again."
        )


    except requests.RequestException:

        return render_template(
            "weather.html",
            city=city,
            error="Could not connect to the weather service. Please check your internet connection."
        )


    except Exception as e:

        print("Weather Error:", e)

        return render_template(
            "weather.html",
            city=city,
            error="Something went wrong while loading weather information."
        )
@app.route('/admin/message/delete/<int:id>')
def delete_message(id):

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "DELETE FROM contact_messages WHERE id=%s",
        (id,)
    )

    conn.commit()

    cursor.close()
    conn.close()
    return redirect('/admin/messages')


@app.route('/admin/message/read/<int:id>')
def read_message(id):

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE contact_messages
        SET status='Read'
        WHERE id=%s
    """,(id,))

    conn.commit()

    cursor.close()
    conn.close()

    return redirect('/admin/messages')


@app.route("/api/shelters")
def api_shelters():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
        name,
        district,
        upazila,
        latitude,
        longitude,
        capacity,
        available,
        status
        FROM shelters
    """)

    shelters = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(shelters)

@app.route("/api/disasters")
def api_disasters():

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
        disaster_name,
        disaster_type,
        location,
        district,
        latitude,
        longitude,
        severity,
        description
        FROM disasters
    """)

    disasters = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(disasters)


if __name__ == "__main__":
    try:
        db = get_db_connection()
        print("Database Connected Successfully")
        db.close()
    except Exception as e:
        print("Database Error:", e)

    app.run(debug=True)