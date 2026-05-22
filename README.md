# Kindling

**Kindling** is the plugin template layer for [Hearth](https://github.com/mcelhennyi/hearth).
It layers on top of the [`.skeleton`](https://github.com/mcelhennyi/.skeleton) process template:
every Kindling plugin repo gets skeleton's process tooling **plus** Kindling's Hearth-specific
plugin contract, templates, and rules.

## What Kindling provides

- `scripts/init-kindling.sh` — two-step init: skeleton layer first, then kindling layer
- `scripts/sync-kindling.sh` — keep both layers up to date
- `templates/plugin-python/` — Python FastAPI plugin starter template (Mantle tokens + theme listener)
- `templates/plugin-react/` — Vite + React + `@kindling/mantle` starter template
- **Python SDK** (repo root) — `kindling.cli`, `kindling.tinder`, `kindling.spark` (CLI, manifest schema, Spark clients)
- **UI:** [`@kindling/mantle`](https://github.com/mcelhennyi/hearth/tree/main/packages/mantle) is published from **hearth**, not vendored here
- `.cursor/rules/kindling-consumer.mdc` / `.claude/rules/kindling-consumer.md` — agent rules
  enforcing the Hearth plugin contract in consumer repos

## Setting up a new Hearth plugin repo

See **`INIT.MD`** for the full two-step walkthrough.

```bash
# Step 1: skeleton layer (process tooling)
SKELETON_SUBMODULE_URL=git@github.com:mcelhennyi/.skeleton.git \
  bash <(curl -fsSL https://raw.githubusercontent.com/mcelhennyi/.skeleton/main/scripts/init-skeleton.sh)

# Step 2: kindling layer (Hearth plugin contract + templates)
KINDLING_SUBMODULE_URL=git@github.com:mcelhennyi/kindling.git \
  bash <(curl -fsSL https://raw.githubusercontent.com/mcelhennyi/kindling/main/scripts/init-kindling.sh)
```

## Syncing updates

```bash
./sync-skeleton   # pull skeleton process tooling updates
./sync-kindling   # pull kindling plugin template + rule updates
```

## Documentation

- Init and sync instructions: [`INIT.MD`](INIT.MD)
- Consumer repo layout: [`docs/kindling-consumer-layout.md`](docs/kindling-consumer-layout.md)
- Maintainer notes: [`docs/kindling-MAINTAINERS.md`](docs/kindling-MAINTAINERS.md)
- AI workflow: [`docs/ai-context.md`](docs/ai-context.md)

## Repo type

Repos using Kindling are listed as `kindling` type in the
[Project Manager registry](https://github.com/mcelhennyi/Project-Manager).
