# FR-0001 closeout — Plugin UI system

**PR pending:** finish-feature opened PR to **`main`** from **`feat/FR-0001-plugin-ui-system`** — refresh merge line after human merge.

## Executive summary

Kindling now ships Mantle-aligned plugin scaffolding: an updated Python static template with full `--hearth-*` tokens and a theme listener, a new React + Vite template pinning `@kindling/mantle` ^0.1.0, `init-kindling --template` / `kindling new --template`, and pytest smoke coverage. Plugin authors have a single doc (`plugin-ui-system.md`) and default templates that match hearth FR-0006 design language.

## Delivered surfaces

| Surface | Location |
|---------|----------|
| Plugin UI bridge doc | `docs/design/plugin-ui-system.md` |
| Python template | `templates/plugin-python/web/dist/index.html` |
| React template | `templates/plugin-react/` |
| Template renderer | `template_render.py`, `scripts/render-plugin-template.py` |
| Init / CLI | `scripts/init-kindling.sh`, `cli/kindling_cli/cli.py` |
| Smoke tests | `scripts/tests/test_plugin_templates.py` |

## Tickets

| Ticket | Summary | Status |
|--------|---------|--------|
| `T-FR-0001-01` | Python template tokens + meta + theme listener | TEST / DEV / VAL **done** |
| `T-FR-0001-02` | React plugin template scaffold | TEST / DEV / VAL **done** |
| `T-FR-0001-03` | `init-kindling --template` flag | TEST / DEV / VAL **done** |
| `T-FR-0001-04` | Template smoke + sync regression | TEST / DEV / VAL **done** |

## Validation

- `python3 -m pytest scripts/tests/ -q` — **5 passed**, 1 skipped (`KINDLING_NETWORK_TESTS` react build)
- Manual: `template_render.render_plugin_template` produces scaffold with required meta + tokens

## Deferred / follow-up

| Item | Tracking |
|------|----------|
| Hearth `kindling` submodule bump on `feat/FR-0006-design-language` | After this PR merges to **`main`** (option A) |
| React template npm build smoke in CI | `KINDLING_NETWORK_TESTS=1` + published `@kindling/mantle@0.1.0` |
| grocery-list FR-0002 integration smoke | Partner FR |

## Suggested next step

Merge the kindling PR to **`main`**, then in hearth `feat/FR-0006-design-language` run `git submodule update --remote kindling` (or pin SHA) and commit the submodule bump before merging FR-0006.

## Options

| Option | When |
|--------|------|
| Bump hearth submodule to merged `main` | Before hearth FR-0006 default-branch merge (recommended) |
| Run `KINDLING_NETWORK_TESTS=1` against hearth `packages/mantle` | Optional pre-merge validation of React template build |

## Audit

- **Merge commit:** *pending*
- **Feature branch:** `feat/FR-0001-plugin-ui-system` (retained on remote)
- **Handoff:** [`handoffs/2026-05-21-finish-feature.md`](handoffs/2026-05-21-finish-feature.md)
