# Kindling maintainer guide

This document is for contributors working **inside the canonical kindling repo**
(`git@github.com:mcelhennyi/kindling.git`). If you are building a Hearth plugin
that *consumes* kindling, see [`docs/kindling-consumer-layout.md`](kindling-consumer-layout.md)
and the rules in `.claude/rules/kindling-consumer.md` / `.cursor/rules/kindling-consumer.mdc`.

## What this repo is

Kindling is the **plugin-layer template** for Hearth. It sits on top of the
skeleton process layer:

```
skeleton (.skeleton/)  — process tooling (FR workflow, AI rules, docs structure)
    └── kindling      — Hearth plugin contract, templates, and plugin-specific rules
```

Consumer plugin repos have **both** as submodules. Kindling's own `init-skeleton`
call bootstraps the skeleton layer first.

## Repo structure

| Path | Purpose |
|---|---|
| `kindling.manifest` | Authoritative list of all kindling-origin files; maps source → consumer destination |
| `.syncignore` | Kindling-internal files NOT copied to consumer roots |
| `scripts/init-kindling.sh` | Two-step init: skeleton → kindling; materialized at consumer roots |
| `scripts/sync-kindling.sh` | Two-step sync: skeleton → kindling; materialized at consumer roots |
| `scripts/kindling-ignore.sh` | Helper: `is_kindling_syncignored()` used by init and sync scripts |
| `scripts/init-skeleton.sh` | Bundled copy of `.skeleton/scripts/init-skeleton.sh` for bootstrap |
| `scripts/skeleton-ignore.sh` | Bundled copy of `.skeleton/scripts/skeleton-ignore.sh` for bootstrap |
| `templates/plugin-python/` | Plugin scaffold template (not materialized to consumer roots) |
| `.cursor/rules/kindling-consumer.mdc` | Always-apply Cursor rules for consumer repos |
| `.claude/rules/kindling-consumer.md` | Mirror of the cursor rule |
| `docs/kindling-consumer-layout.md` | Layout reference for consumer repos |
| `CHANGELOG.md` | Version history; consumers read after `sync-kindling` |
| `INIT.MD` | Quickstart guide for new plugin repos |

## Making changes

### Rule changes (`.cursor/rules/kindling-consumer.mdc` / `.claude/rules/kindling-consumer.md`)

These two files **must stay identical in content**. When editing one, immediately
update the other in the same commit. They are materialized to consumer roots on
every `sync-kindling`.

### Script changes (`scripts/init-kindling.sh`, `scripts/sync-kindling.sh`)

- Always test on a throw-away consumer repo before pushing.
- Bump the version comment at the top of the script.
- Add an entry to `CHANGELOG.md` under `[Unreleased]`.

### Template changes (`templates/plugin-python/`)

Templates are **not** pushed to consumer roots automatically. They are a scaffold
reference; `init-kindling.sh` does not copy them. Developers run
`kindling new <slug>` (or copy manually) to start from a template.

Changes here should be mirrored to existing reference plugins (such as
`apps/groceries/` in the Hearth repo) as appropriate.

### Syncing the bundled skeleton copies

`scripts/init-skeleton.sh` and `scripts/skeleton-ignore.sh` are **verbatim copies**
of the equivalent files from `.skeleton/scripts/`. When `.skeleton/` updates those
files, copy them here in the same PR so kindling consumers can still bootstrap
from a fresh clone without needing a pre-existing `.skeleton/`.

After updating, run:

```bash
diff scripts/init-skeleton.sh .skeleton/scripts/init-skeleton.sh
diff scripts/skeleton-ignore.sh .skeleton/scripts/skeleton-ignore.sh
```

Both diffs should be empty before committing.

### `kindling.manifest` changes

The manifest tracks every kindling-origin file. When adding a new file to be
materialized at consumer roots:

1. Add a line: `source_path|destination_path`
2. If it should **not** be copied to consumers, also add `destination_path` to
   `.syncignore`.
3. Update `CHANGELOG.md`.

### Releasing a new version

1. Move `[Unreleased]` entries to a dated `[X.Y.Z]` section in `CHANGELOG.md`.
2. Tag the commit: `git tag -a vX.Y.Z -m "kindling vX.Y.Z"`
3. Push tag: `git push origin vX.Y.Z`

Consumer repos pick up the new version on `./sync-kindling`.

## Testing

There is no automated test suite for the kindling scripts. Test manually:

```bash
# Create a throw-away consumer
mkdir /tmp/test-plugin && cd /tmp/test-plugin
git init && git remote add origin git@github.com:test/test-plugin.git
cp /path/to/kindling/init-kindling .
chmod +x init-kindling
./init-kindling
# Verify: .skeleton/ and .kindling/ submodules present
# Verify: sync-kindling wrapper, scripts/ present
# Verify: .cursor/rules/kindling-consumer.mdc present
# Verify: .claude/rules/kindling-consumer.md present
```

## Branching

The `main` branch is the production branch. Consumer repos pin `.kindling/` to
`main` (via `git submodule update --remote`). Avoid force-pushing `main`.

Feature branches follow the skeleton FR-NNNN workflow if this repo uses it, or
topic branches (`fix/…`, `feat/…`) for smaller changes.
