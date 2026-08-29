import pytest
from unittest.mock import MagicMock
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_healthcheck(client):
    """Test the /healthcheck endpoint"""
    response = client.get('/healthcheck')
    assert response.status_code == 200
    assert response.json == {"status": "healthy"}

def test_readyz_success(client, mocker):
    """Test the /readyz endpoint with a successful DB connection"""
    # Mock get_db_connection to return a dummy connection and no error
    mock_conn = MagicMock()
    mocker.patch('app.get_db_connection', return_value=(mock_conn, None))
    
    response = client.get('/readyz')
    assert response.status_code == 200
    assert response.json == {"status": "ready", "message": "Connected to PostgreSQL successfully!"}
    mock_conn.close.assert_called_once()

def test_readyz_failure(client, mocker):
    """Test the /readyz endpoint when DB connection fails"""
    mocker.patch('app.get_db_connection', return_value=(None, "Connection timeout"))
    
    response = client.get('/readyz')
    assert response.status_code == 503
    assert response.json == {"status": "not ready", "details": "Connection timeout"}

def test_index_success(client, mocker):
    """Test the / endpoint successfully returning data"""
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    
    # Setup mock to simulate fetching data
    mock_cursor.fetchone.return_value = [2] # Assume table is not empty
    mock_cursor.fetchall.return_value = [(1, "Sample Data 1"), (2, "Sample Data 2")]
    
    mock_conn.cursor.return_value.__enter__.return_value = mock_cursor
    
    mocker.patch('app.get_db_connection', return_value=(mock_conn, None))
    
    response = client.get('/')
    assert response.status_code == 200
    assert response.json == {
        "status": "success", 
        "data": [
            {"id": 1, "data_value": "Sample Data 1"},
            {"id": 2, "data_value": "Sample Data 2"}
        ]
    }
    mock_conn.commit.assert_called_once()
    mock_conn.close.assert_called_once()

def test_index_db_error(client, mocker):
    """Test the / endpoint when DB connection fails"""
    mocker.patch('app.get_db_connection', return_value=(None, "Auth failed"))
    
    response = client.get('/')
    assert response.status_code == 500
    assert response.json == {"status": "error", "message": "Failed to connect to database", "details": "Auth failed"}
