# Kindling consumer repo layout

A fully-initialized Kindling consumer repo has the following structure.
Entries marked *(kindling)* are materialized by `init-kindling` / `sync-kindling`.
Entries marked *(skeleton)* are materialized by the embedded `init-skeleton` / `sync-skeleton`.
Product files (plugin code, tests, UI) are written by the developer.

```
<plugin-slug>/
│
├── .kindling/              # Kindling submodule (git@github.com:mcelhennyi/kindling.git)
├── .skeleton/              # Skeleton submodule (git@github.com:mcelhennyi/.skeleton.git)
│
│   # Init / sync wrappers (kindling)
├── init-kindling           # ./init-kindling  — first-time init
├── sync-kindling           # ./sync-kindling  — update both layers
│
│   # Wrappers re-materialized from skeleton (kindling bundles a copy for bootstrap)
├── scripts/
│   ├── init-kindling.sh        # (kindling)
│   ├── sync-kindling.sh        # (kindling)
│   ├── kindling-ignore.sh      # (kindling)
│   ├── init-skeleton.sh        # (kindling, mirrors .skeleton copy)
│   ├── skeleton-ignore.sh      # (kindling, mirrors .skeleton copy)
│   ├── sync-skeleton.sh        # (skeleton)
│   └── install                 # (product) — plugin install hook
│
│   # AI rules (skeleton)
├── .claude/
│   ├── rules/
│   │   ├── development-standards.md
│   │   ├── docs-authority-and-escalation.md
│   │   ├── growth-monitoring.md
│   │   ├── growth-required.md
│   │   ├── kindling-consumer.md    # (kindling) plugin-specific rules
│   │   ├── rework-required.md
│   │   └── tag-reservation.md
│   └── commands/               # (skeleton) slash-command stubs
│
├── .cursor/
│   ├── rules/
│   │   ├── main.mdc
│   │   ├── kindling-consumer.mdc   # (kindling) plugin-specific rules
│   │   └── …
│   └── skills/                 # (skeleton) skill files
│
│   # Process docs (skeleton)
├── docs/
│   ├── ai-context.md
│   ├── design/
│   │   └── documentation-style.md
│   └── skeleton-project-overlays.md
│
├── tasks/
│   ├── handoffs/
│   └── …
│
│   # Plugin contract (product)
├── tinder.toml
│
│   # Python backend (product)
├── <pkg>/
│   ├── __init__.py
│   ├── app.py          # FastAPI create_app() factory
│   └── db.py           # SQLite helpers
│
│   # Static UI (product)
├── web/
│   └── dist/
│       └── index.html
│
│   # Tests (product)
├── tests/
│   ├── __init__.py
│   └── test_<pkg>.py
│
│   # Plugin shim (product, must stay executable)
├── plugin
│
│   # Python packaging (product)
└── pyproject.toml
```

## Layer comparison

| File / directory | Origin | Overwritten by sync? |
|---|---|---|
| `.kindling/` | kindling submodule | `sync-kindling` (ff-only) |
| `.skeleton/` | skeleton submodule | `sync-kindling` → `sync-skeleton` |
| `scripts/init-kindling.sh` | kindling | yes |
| `scripts/sync-kindling.sh` | kindling | yes |
| `scripts/init-skeleton.sh` | kindling (bundled skeleton copy) | yes |
| `.claude/rules/kindling-consumer.md` | kindling | yes |
| `.cursor/rules/kindling-consumer.mdc` | kindling | yes |
| All other `.claude/rules/` | skeleton | yes (via sync-skeleton) |
| `tinder.toml` | product | **never** |
| `<pkg>/`, `tests/`, `web/` | product | **never** |
| `plugin`, `scripts/install` | product | **never** (must stay executable) |

## Initializing a new plugin repo

```bash
# 1. Create a bare repo and push to GitHub
git init <plugin-slug> && cd <plugin-slug>
git remote add origin git@github.com:<org>/<plugin-slug>.git

# 2. Run init-kindling (bootstraps skeleton then kindling layer)
curl -fsSL https://raw.githubusercontent.com/mcelhennyi/kindling/main/init-kindling -o init-kindling
chmod +x init-kindling
./init-kindling

# 3. Scaffold plugin files (tinder.toml, <pkg>/, web/, tests/, plugin, scripts/install)
# Use .kindling/templates/plugin-python/ as a starting point.

# 4. Commit everything
git add -A && git commit -m "feat: init plugin <plugin-slug>"
git push -u origin main
```

## Keeping a plugin repo up to date

```bash
./sync-kindling          # updates .skeleton/ then .kindling/ and re-applies manifests
# Read .skeleton/CHANGELOG.md and .kindling/CHANGELOG.md after each sync.
```
