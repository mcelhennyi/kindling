# Initializing a Hearth plugin repo with Kindling

Kindling is a **two-layer template**: every Kindling plugin repo also gets the
**skeleton process layer** first. Setup is two explicit steps so each layer is
independently auditable and upgradeable.

## New plugin repo — recommended workflow

```bash
# 1. Create the repo (empty) and set origin
git init my-plugin && cd my-plugin
git remote add origin git@github.com:<you>/my-plugin.git
git commit --allow-empty -m "chore: init"
git push -u origin main

# 2. Step 1 — skeleton layer (process tooling: tickets, AI rules, docs structure)
SKELETON_SUBMODULE_URL=git@github.com:mcelhennyi/.skeleton.git \
  bash <(curl -fsSL https://raw.githubusercontent.com/mcelhennyi/.skeleton/main/scripts/init-skeleton.sh)
git add -A && git commit -m "chore: init skeleton"
git push

# 3. Step 2 — kindling layer (Hearth plugin templates + rules)
KINDLING_SUBMODULE_URL=git@github.com:mcelhennyi/kindling.git \
  bash <(curl -fsSL https://raw.githubusercontent.com/mcelhennyi/kindling/main/scripts/init-kindling.sh)
git add -A && git commit -m "chore: init kindling"
git push
```

After init the repo has:
- `.skeleton/` — process tooling submodule (from `.skeleton` repo)
- `.kindling/` — plugin template submodule (this repo)
- Skeleton files at root: `.cursor/rules/`, `.claude/rules/`, `docs/`, `tasks/`
- Kindling additions at root: `init-kindling`, `sync-kindling`, `scripts/init-kindling.sh`,
  `scripts/sync-kindling.sh`, kindling-specific Cursor/Claude rules

## Syncing template updates

```bash
# Sync skeleton layer (process/tooling updates)
./sync-skeleton          # or: bash .skeleton/scripts/sync-skeleton.sh

# Sync kindling layer (plugin template and rules updates)
./sync-kindling          # or: bash .kindling/scripts/sync-kindling.sh
```

Read **`.skeleton/CHANGELOG.md`** after skeleton sync and **`.kindling/CHANGELOG.md`**
after kindling sync. Follow any **`Consumer manual:`** bullets.

## What each layer provides

| Layer | Submodule | Provides |
|-------|-----------|---------|
| Skeleton | `.skeleton/` | Process: tickets, AI agent rules, docs structure, feature workflow |
| Kindling | `.kindling/` | Plugin: Hearth plugin contract rules, `kindling new <slug>` template source |

## Environment variables (`init-kindling.sh`)

| Variable | Purpose |
|----------|---------|
| `SKELETON_SUBMODULE_URL` | Override skeleton submodule URL (default: `git@github.com:mcelhennyi/.skeleton.git`) |
| `KINDLING_SUBMODULE_URL` | Override kindling submodule URL (default: `git@github.com:mcelhennyi/kindling.git`) |
| `SKELETON_SUBMODULE_BRANCH` | Skeleton branch (default: `main`) |
| `KINDLING_SUBMODULE_BRANCH` | Kindling branch (default: `main`) |

## Maintainer rules

When **`KINDLING_REPO`** is present at the checkout root, you are in the canonical
Kindling template repository. See **`docs/kindling-MAINTAINERS.md`**.
