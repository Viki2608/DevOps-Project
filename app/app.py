from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

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
    
    conn.close()
    return jsonify({"status": "success", "message": "Connected to PostgreSQL successfully!"})

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
