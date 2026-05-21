"""SQLite persistence for the {{ plugin_name }} plugin."""

from __future__ import annotations

import sqlite3
from pathlib import Path


def get_db(path: Path | str) -> sqlite3.Connection:
    conn = sqlite3.connect(str(path), check_same_thread=False)
    conn.row_factory = sqlite3.Row
    return conn


def init_db(conn: sqlite3.Connection) -> None:
    # TODO: define your schema here
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS example (
            id   INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT    NOT NULL
        )
        """
    )
    conn.commit()
