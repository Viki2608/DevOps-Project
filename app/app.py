from flask import Flask, jsonify
import psycopg2
import os
from prometheus_flask_exporter import PrometheusMetrics

# test
app = Flask(__name__)
metrics = PrometheusMetrics(app)

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.environ.get('DB_HOST', 'localhost'),
            database=os.environ.get('DB_NAME', 'appdb'),
            user=os.environ.get('DB_USER', 'dbadmin'),
            password=os.environ.get('DB_PASSWORD', 'secret')
        )
        return conn, None
    except Exception as e:
        return None, str(e)

@app.route('/')
def index():
    conn, err = get_db_connection()
    if err:
        return jsonify({"status": "error", "message": "Failed to connect to database", "details": err}), 500
    
    try:
        with conn.cursor() as cur:
            # Ensure table exists for demonstration purposes
            cur.execute("""
                CREATE TABLE IF NOT EXISTS app_data (
                    id SERIAL PRIMARY KEY,
                    data_value VARCHAR(255) NOT NULL
                )
            """)
            
            # Insert dummy data if the table is empty
            cur.execute("SELECT COUNT(*) FROM app_data")
            if cur.fetchone()[0] == 0:
                cur.execute("INSERT INTO app_data (data_value) VALUES ('Sample Data 1'), ('Sample Data 2')")
                
            cur.execute("SELECT * FROM app_data")
            rows = cur.fetchall()
            
            data = [{"id": row[0], "data_value": row[1]} for row in rows]
            
        conn.commit()
        return jsonify({"status": "success", "data": data})
    except Exception as e:
        conn.rollback()
        return jsonify({"status": "error", "message": "Failed to fetch data", "details": str(e)}), 500
    finally:
        conn.close()

@app.route('/healthcheck')
def healthcheck():
    return jsonify({"status": "healthy"})

@app.route('/readyz')
def readyz():
    conn, err = get_db_connection()
    if err:
        return jsonify({"status": "not ready", "details": err}), 503
    
    conn.close()
    return jsonify({"status": "ready", "message": "Connected to PostgreSQL successfully!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
