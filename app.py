from flask import Flask, render_template, request, redirect, url_for, session
from config import get_db_connection

app = Flask(__name__)
app.secret_key = "smart_disaster_secret_key"


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

    cursor.execute("""
        SELECT name, user_type
        FROM users
        WHERE id = %s
    """, (session["user_id"],))

    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if not user:
        return redirect(url_for("login"))

    return render_template(
        "dashboard.html",
        name=user["name"],
        user_type=user["user_type"]
    )

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


@app.route("/about")
def about():
    return render_template("about.html")


@app.route("/contact")
def contact():
    return render_template("contact.html")


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

if __name__ == "__main__":
    app.run(debug=True)