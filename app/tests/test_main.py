import pytest

from main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_health_check(client):
    response = client.get("/")
    data = response.get_json()
    assert response.status_code == 200
    assert data["status"] == "healthy"
    assert "timestamp" in data


def test_status(client):
    response = client.get("/api/status")
    data = response.get_json()
    assert response.status_code == 200
    assert data["application"] == "devops-na-pratica"
    assert data["status"] == "running"
    assert "uptime_seconds" in data
    assert "environment" in data


def test_info(client):
    response = client.get("/api/info")
    data = response.get_json()
    assert response.status_code == 200
    assert data["application"] == "devops-na-pratica"
    assert data["version"] == "1.0.0"
    assert "python_version" in data
    assert "platform" in data
    assert "architecture" in data
