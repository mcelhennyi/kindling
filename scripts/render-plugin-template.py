#!/usr/bin/env python3
"""CLI wrapper for template_render — used by init-kindling.sh."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

_ROOT = Path(__file__).resolve().parents[1]
if str(_ROOT) not in sys.path:
    sys.path.insert(0, str(_ROOT))

from template_render import KindlingTemplateError, render_plugin_template  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description="Render a Kindling plugin template")
    parser.add_argument("--slug", required=True)
    parser.add_argument("--template", choices=("python", "react"), default="python")
    parser.add_argument("--dest", type=Path, required=True, help="Destination directory")
    parser.add_argument(
        "--into-root",
        action="store_true",
        help="Render into dest directly (init-kindling consumer repo)",
    )
    parser.add_argument(
        "--kindling-root",
        type=Path,
        default=_ROOT,
        help="Canonical kindling checkout with templates/",
    )
    args = parser.parse_args()
    try:
        out = render_plugin_template(
            args.dest,
            slug=args.slug,
            template=args.template,
            kindling_root=args.kindling_root,
            into_root=args.into_root,
        )
    except KindlingTemplateError as exc:
        print(f"render-plugin-template: {exc}", file=sys.stderr)
        return 1
    print(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
