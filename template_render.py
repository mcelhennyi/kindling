"""Render Kindling plugin templates into a consumer directory.

Substitutes ``{{ token }}`` placeholders in file paths and file contents.
Used by ``kindling new`` and ``init-kindling --template``.
"""

from __future__ import annotations

import os
import re
import shutil
from pathlib import Path
from typing import Mapping

_SLUG_RE = re.compile(r"^[a-z][a-z0-9-]{0,31}$")
_PLACEHOLDER_RE = re.compile(r"\{\{\s*(\w+)\s*\}\}")

VALID_TEMPLATES = frozenset({"python", "react"})


class KindlingTemplateError(ValueError):
    """Invalid slug, template name, or destination."""


def slug_to_python_package(slug: str) -> str:
    return slug.replace("-", "_")


def slug_to_plugin_name(slug: str) -> str:
    return " ".join(part.capitalize() for part in slug.split("-"))


def build_context(
    slug: str,
    *,
    description: str | None = None,
    mantle_dependency: str = "^0.1.0",
    mantle_prepare_script: str = 'node -e "console.log(\\"using published @kindling/mantle\\")"',
) -> dict[str, str]:
    if not _SLUG_RE.match(slug):
        raise KindlingTemplateError(
            f"slug '{slug}' must match ^[a-z][a-z0-9-]{{0,31}}$ (kebab-case ASCII, ≤ 32 chars)"
        )
    name = slug_to_plugin_name(slug)
    return {
        "plugin_slug": slug,
        "python_package": slug_to_python_package(slug),
        "plugin_name": name,
        "plugin_description": description or f"{name} Hearth plugin",
        "mantle_dependency": mantle_dependency,
        "mantle_prepare_script": mantle_prepare_script,
    }


def substitute(text: str, context: Mapping[str, str]) -> str:
    def repl(match: re.Match[str]) -> str:
        key = match.group(1)
        if key not in context:
            raise KindlingTemplateError(f"unknown template token: {key}")
        return context[key]

    return _PLACEHOLDER_RE.sub(repl, text)


def template_dir(kindling_root: Path, template: str) -> Path:
    if template not in VALID_TEMPLATES:
        raise KindlingTemplateError(
            f"unknown template '{template}'; choose from: {', '.join(sorted(VALID_TEMPLATES))}"
        )
    path = kindling_root / "templates" / f"plugin-{template}"
    if not path.is_dir():
        raise KindlingTemplateError(f"template directory not found: {path}")
    return path


def render_plugin_template(
    dest_parent: Path,
    *,
    slug: str,
    template: str = "python",
    kindling_root: Path | None = None,
    description: str | None = None,
    overwrite: bool = False,
    into_root: bool = False,
) -> Path:
    """Copy ``templates/plugin-<template>/`` with substitution.

    When *into_root* is false (``kindling new``), writes under ``dest_parent / slug``.
    When true (``init-kindling --template``), writes directly into *dest_parent* (the repo root).
    """
    root = kindling_root or _find_kindling_root()
    src = template_dir(root, template)
    dest_parent = dest_parent.resolve()
    dest = dest_parent if into_root else (dest_parent / slug).resolve()
    context = build_context(
        slug,
        description=description,
        **_mantle_context(root, dest, template),
    )

    if into_root:
        if (dest / "tinder.toml").exists() and not overwrite:
            raise KindlingTemplateError(
                f"tinder.toml already exists in {dest}; remove it or pass overwrite"
            )
    elif dest.exists() and any(dest.iterdir()) and not overwrite:
        raise KindlingTemplateError(f"destination already exists: {dest}")
    else:
        dest.mkdir(parents=True, exist_ok=True)

    for item in sorted(src.rglob("*")):
        rel = item.relative_to(src)
        rel_str = substitute(str(rel), context)
        target = dest / rel_str
        if item.is_dir():
            target.mkdir(parents=True, exist_ok=True)
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        raw = item.read_bytes()
        try:
            text = raw.decode("utf-8")
        except UnicodeDecodeError:
            shutil.copy2(item, target)
            continue
        target.write_text(substitute(text, context), encoding="utf-8")
        if rel_str.endswith("plugin") or rel_str.endswith("scripts/install"):
            target.chmod(0o755)

    return dest


def _mantle_context(kindling_root: Path, dest: Path, template: str) -> dict[str, str]:
    """Use local Kindling Mantle for generated React templates when available."""
    fallback = {
        "mantle_dependency": "^0.1.0",
        "mantle_prepare_script": 'node -e "console.log(\\"using published @kindling/mantle\\")"',
    }
    if template != "react":
        return fallback
    mantle_root = kindling_root / "mantle"
    if not (mantle_root / "package.json").is_file():
        return fallback

    relative = _relative_path(mantle_root.resolve(), dest.resolve())
    return {
        "mantle_dependency": f"file:{relative}",
        "mantle_prepare_script": (
            f"npm install --prefix {relative} --no-package-lock "
            f"&& npm run --prefix {relative} build"
        ),
    }


def _relative_path(target: Path, start: Path) -> str:
    relative = Path(os.path.relpath(target, start)).as_posix()
    if not relative.startswith("."):
        relative = f"./{relative}"
    return relative


def _find_kindling_root() -> Path:
    here = Path(__file__).resolve().parent
    if (here / "templates").is_dir():
        return here
    raise KindlingTemplateError(
        "could not locate kindling templates/; run from a kindling checkout or pass kindling_root"
    )
