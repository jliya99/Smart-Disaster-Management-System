import mysql.connector


def get_db_connection():
    connection = mysql.connector.connect(
        host="127.0.0.1",
        user="root",
        password="NewPass@12345",
        database="smart_disaster_db",
        port=3306
    )

    return connection