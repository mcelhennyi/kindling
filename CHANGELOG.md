# Kindling changelog

Audience: **Kindling template maintainers** and **kindling consumer** repository owners.

After running `./sync-kindling`, read this file. Follow any **`Consumer manual:`** or
**`[consumer manual]`** bullets in the `[Unreleased]` block, then check
**Deprecations**.

---

## [Unreleased]

### Template

- **FR-0001 plugin-ui-system:** Mantle-aligned Python `web/dist/index.html`; new `templates/plugin-react/` with `@kindling/mantle` ^0.1.0; `init-kindling --template` and `kindling new --template`.

### Mantle

- **Hearth FR-0007:** `@kindling/mantle` source, tests, package metadata, README, changelog, and build config now live in Kindling at `mantle/`. Hearth `packages/mantle/` is no longer the authoritative package home.
- **Consumer manual:** Repos that used a Hearth-relative path for Mantle must switch to `@kindling/mantle` from Kindling `mantle/`, a private package artifact, or a later registry release. Verify with the consumer app's package install plus its standalone UI build.

### Deprecations

- Hearth-relative Mantle imports or package paths such as `../hearth/packages/mantle` are deprecated for plugin repos. Use `@kindling/mantle` instead.

---

## [0.1.0] — 2026-05-20

### Template

- Initial Kindling template repository.
- `scripts/init-kindling.sh` — two-step init: skeleton layer first, then kindling layer.
- `scripts/sync-kindling.sh` — update `.skeleton/` then `.kindling/` and re-apply manifest.
- `kindling.manifest` — files materialized to consumer plugin repo roots.
- `templates/plugin-python/` — Python FastAPI plugin template (tinder.toml, app, db, tests, web UI).
- `.cursor/rules/kindling-consumer.mdc` / `.claude/rules/kindling-consumer.md` — consumer rules.
