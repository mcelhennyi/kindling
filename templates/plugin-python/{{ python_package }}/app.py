"""{{ plugin_name }} plugin FastAPI application.

Routes:
  GET  /health    → liveness probe
"""

from __future__ import annotations

import os
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from .db import get_db, init_db

_HERE = Path(__file__).parent


def _db_path() -> Path:
    var = Path(os.environ.get("HEARTH_VAR_DIR", "var/hearth"))
    p = var / "plugins" / "{{ plugin_slug }}" / "db.sqlite"
    p.parent.mkdir(parents=True, exist_ok=True)
    return p


def _try_publish(event: str, payload: dict) -> None:
    """Fire-and-forget Spark publish; skip silently if broker unavailable."""
    sock = os.environ.get("HEARTH_SPARK_SOCK")
    if not sock:
        return
    try:
        import asyncio

        from spark.client import SparkClient  # type: ignore[import-not-found]

        async def _pub() -> None:
            client = SparkClient(slug="{{ plugin_slug }}", sock_path=Path(sock))
            await client.connect()
            await client.publish(event, payload)
            await client.close()

        asyncio.run(_pub())
    except Exception:
        pass  # broker unavailable in dev/test — not fatal


def create_app() -> FastAPI:
    app = FastAPI(title="{{ plugin_name }} Plugin")

    conn = get_db(_db_path())
    init_db(conn)

    @app.get("/health")
    def health() -> dict:
        return {"ok": True}

    # TODO: add your routes here

    # Serve static UI from web/dist if it exists
    web_dist = _HERE.parent / "web" / "dist"
    if web_dist.is_dir():
        app.mount("/", StaticFiles(directory=str(web_dist), html=True), name="static")

    return app
