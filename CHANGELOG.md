# Kindling changelog

Audience: **Kindling template maintainers** and **kindling consumer** repository owners.

After running `./sync-kindling`, read this file. Follow any **`Consumer manual:`** or
**`[consumer manual]`** bullets in the `[Unreleased]` block, then check
**Deprecations**.

---

## [Unreleased]

### Template

_No unreleased changes._

### Deprecations

_None._

---

## [0.1.0] — 2026-05-20

### Template

- Initial Kindling template repository.
- `scripts/init-kindling.sh` — two-step init: skeleton layer first, then kindling layer.
- `scripts/sync-kindling.sh` — update `.skeleton/` then `.kindling/` and re-apply manifest.
- `kindling.manifest` — files materialized to consumer plugin repo roots.
- `templates/plugin-python/` — Python FastAPI plugin template (tinder.toml, app, db, tests, web UI).
- `.cursor/rules/kindling-consumer.mdc` / `.claude/rules/kindling-consumer.md` — consumer rules.
