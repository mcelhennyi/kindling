# FR-0001 — Plugin UI system

**Status:** `design` · **Started:** 2026-05-21

Authors the plugin-side design-language layer so Hearth plugins built from kindling render with Mantle-aligned UI by default. Pairs with **hearth FR-0006** (which ships `@kindling/mantle`) and **grocery-list FR-0002** (which consumes both).

## Scope

1. **Author `docs/design/plugin-ui-system.md`** (closes `DG-D1`) — the bridge doc for plugin authors: required meta tags (`viewport-fit=cover`, `theme-color`), Mantle tokens, safe-area handling, postMessage protocol contract, when to declare `[ui.chrome]` slots, `@kindling/mantle` import pattern. Cross-links to hearth `mantle-ui.md` + `plugin-contract.md` as authoritative.
2. **Replace `templates/plugin-python/web/dist/index.html`** (closes `DF-T1`) with a minimal Mantle-token-aware page (tokens, meta, safe-area, comment pointing to plugin-ui-system).
3. **Add `templates/plugin-react/`** (closes `RW-T1`) — minimal React + Vite + `@kindling/mantle` worked example showing token consumption, chrome-slot mounting, theme listener.
4. **Extend `kindling-consumer` rule** (closes `DF-C1`) — UI contract clause: plugins must use Mantle tokens, not render duplicate top/bottom bars, register chrome slots in `tinder.toml` when surfacing shell-mounted buttons, listen for `hearth.theme`.
5. **Mirror in `.cursor/rules/kindling-consumer.mdc`** (agent-sync rule).

## Dependencies

- **hearth FR-0006** ships `@kindling/mantle` v0. Until that lands, `templates/plugin-react/` will pin a `workspace:*` or pre-release reference; the design doc can ship first.

## Tags reserved

See [`tasks/TAG-REGISTRY.md`](../../TAG-REGISTRY.md):
- DG-D1 (plugin-ui-system doc missing) — **FIX** this FR
- DF-T1 (template tokens missing) — **TAG** resolved in DEV stage
- DF-C1 (consumer rule UI contract missing) — **TAG** resolved with DG-D1 commit
- RW-T1 (no plugin-react template) — **TAG** resolved in DEV stage

## Artifacts

- [`00-intake.md`](00-intake.md)
- `10-design-00-skeleton.md` *(to be authored)*
- `20-tickets-dag.md` *(to be authored)*
- `tickets.md` *(canonical, to be authored)*
- `serial-diary.md`
- [`parallel/`](parallel/)
- [`handoffs/`](handoffs/)
- `90-closeout.md` *(at closeout)*
