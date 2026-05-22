"""Template smoke tests for FR-0001 plugin-ui-system."""

from __future__ import annotations

import re
import subprocess
import tempfile
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
REQUIRED_META = (
    "viewport-fit=cover",
    "theme-color",
    "apple-mobile-web-app-capable",
    "apple-mobile-web-app-status-bar-style",
)
HEARTH_TOKEN_PREFIX = "--hearth-"


@pytest.fixture
def kindling_root() -> Path:
    return ROOT


def _render(tmp: Path, slug: str, template: str) -> Path:
    from template_render import render_plugin_template

    return render_plugin_template(tmp, slug=slug, template=template, kindling_root=ROOT)


def test_python_template_html_contract(kindling_root: Path) -> None:
    src = kindling_root / "templates/plugin-python/web/dist/index.html"
    text = src.read_text(encoding="utf-8")
    for needle in REQUIRED_META:
        assert needle in text, f"missing {needle!r} in python template"
    assert ":root" in text and HEARTH_TOKEN_PREFIX in text
    assert "hearth.theme" in text
    assert "e.origin" in text or "event.origin" in text


def test_render_python_scaffold_has_tokens_and_listener() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        root = _render(Path(tmp), "demo-shop", "python")
        html = (root / "web/dist/index.html").read_text(encoding="utf-8")
        for needle in REQUIRED_META:
            assert needle in html
        assert re.search(r":root\s*\{[^}]*--hearth-bg", html, re.DOTALL)
        assert "hearth.theme" in html
        assert (root / "tinder.toml").is_file()
        assert "demo-shop" in (root / "tinder.toml").read_text()


def test_render_react_scaffold_files() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        root = _render(Path(tmp), "demo-react", "react")
        assert (root / "package.json").is_file()
        assert "@kindling/mantle" in (root / "package.json").read_text()
        assert (root / "src/App.tsx").is_file()
        assert (root / "vite.config.ts").is_file()
        html = (root / "index.html").read_text(encoding="utf-8")
        for needle in REQUIRED_META:
            assert needle in html


def test_init_kindling_template_arg_parsing() -> None:
    script = ROOT / "scripts/init-kindling.sh"
    text = script.read_text(encoding="utf-8")
    assert "--template" in text
    assert "render-plugin-template.py" in text


def test_kindling_new_rejects_unknown_template() -> None:
    from template_render import KindlingTemplateError, render_plugin_template

    with tempfile.TemporaryDirectory() as tmp:
        with pytest.raises(KindlingTemplateError):
            render_plugin_template(Path(tmp), slug="ok", template="vue", kindling_root=ROOT)


@pytest.mark.skipif(
    not __import__("os").environ.get("KINDLING_NETWORK_TESTS"),
    reason="set KINDLING_NETWORK_TESTS=1 to run npm build smoke",
)
def test_react_template_builds_when_mantle_available() -> None:
    mantle_path = __import__("os").environ.get("KINDLING_MANTLE_PATH")
    with tempfile.TemporaryDirectory() as tmp:
        root = _render(Path(tmp), "build-demo", "react")
        pkg = root / "package.json"
        if mantle_path:
            import json

            data = json.loads(pkg.read_text(encoding="utf-8"))
            data["dependencies"]["@kindling/mantle"] = f"file:{mantle_path}"
            pkg.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
        subprocess.run(["npm", "install"], cwd=root, check=True, capture_output=True)
        subprocess.run(["npm", "run", "build"], cwd=root, check=True, capture_output=True)
        assert (root / "web/dist/index.html").is_file()
