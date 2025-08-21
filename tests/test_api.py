"""Tests for the TrueEye API.

These tests cover the health endpoint and the analyse endpoint in local mode. Remote
mode is not tested because it requires a live LangFlow service and API key.
"""

import os
from fastapi.testclient import TestClient

from trueeye.api import create_app


def test_health_endpoint() -> None:
    """The /health endpoint should return a healthy status."""
    client = TestClient(create_app())
    resp = client.get("/health")
    assert resp.status_code == 200
    data = resp.json()
    assert data["status"] == "healthy"
    assert "service" in data


def test_analyze_local_mode() -> None:
    """When TE_PROVIDER is set to local, /analyze returns a stubbed response."""
    os.environ["TE_PROVIDER"] = "local"
    app = create_app()
    client = TestClient(app)
    url = "https://example.com/article"
    resp = client.post("/analyze", json={"url": url})
    assert resp.status_code == 200
    body = resp.json()
    assert body["success"] is True
    assert url in body["result"]