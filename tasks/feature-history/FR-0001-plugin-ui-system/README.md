# FR-0001 — Plugin UI system

**Status:** `done` (PR pending merge to **`main`**) · **Started:** 2026-05-21

Closeout: [`90-closeout.md`](90-closeout.md) · Handoff: [`handoffs/2026-05-21-finish-feature.md`](handoffs/2026-05-21-finish-feature.md)

Authors the plugin-side design-language layer so Hearth plugins built from kindling render with Mantle-aligned UI by default. Pairs with **hearth FR-0006** (`@kindling/mantle` v0.1.0) and **grocery-list FR-0002**.

## Delivered

1. **`docs/design/plugin-ui-system.md`** — bridge doc for plugin authors (tokens, meta, postMessage, chrome slots).
2. **`templates/plugin-python/web/dist/index.html`** — Mantle tokens, meta, theme listener.
3. **`templates/plugin-react/`** — Vite + React + `@kindling/mantle` ^0.1.0 example.
4. **`init-kindling --template`** / **`kindling new --template`** — scaffold tooling via `template_render.py`.
5. **`kindling-consumer` rule** — UI contract (prior commit `f34cb98`).

## Artifacts

- [`00-intake.md`](00-intake.md)
- [`10-design-00-skeleton.md`](10-design-00-skeleton.md)
- [`20-tickets-dag.md`](20-tickets-dag.md)
- [`tickets.md`](tickets.md)
- [`90-closeout.md`](90-closeout.md)
- [`handoffs/`](handoffs/)
