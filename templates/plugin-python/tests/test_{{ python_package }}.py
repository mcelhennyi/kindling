"""Unit tests for {{ plugin_name }} plugin.

Run inside Docker:
    docker compose run --rm <service> pytest
"""

from __future__ import annotations

import pytest
from fastapi.testclient import TestClient

from {{ python_package }}.app import create_app
from {{ python_package }}.db import get_db, init_db


@pytest.fixture()
def client(tmp_path):
    db_path = tmp_path / "test.sqlite"
    conn = get_db(db_path)
    init_db(conn)

    app = create_app.__wrapped__(conn) if hasattr(create_app, "__wrapped__") else None
    if app is None:
        import os
        os.environ["HEARTH_VAR_DIR"] = str(tmp_path)
        app = create_app()

    with TestClient(app) as c:
        yield c


def test_health(client: TestClient) -> None:
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json() == {"ok": True}
