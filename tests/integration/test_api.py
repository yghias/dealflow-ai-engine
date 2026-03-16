from fastapi.testclient import TestClient

from dealflow_ai_engine.api.app import app


client = TestClient(app)


def test_health_endpoint() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "ok"


def test_mock_signals_endpoint() -> None:
    response = client.get("/signals/mock")
    assert response.status_code == 200
    assert len(response.json()) >= 1


def test_ranked_queue_endpoint() -> None:
    response = client.get("/signals/queue")
    assert response.status_code == 200
    assert response.json()["items"][0]["organization_name"] == "Acme Data Systems"
