# FR-0001 — Intake

**Title:** Plugin UI system — design-language bridge for kindling consumers
**Date opened:** 2026-05-21
**Driver:** Cross-repo design-language audit (2026-05-21) found that kindling provides the **process and contract skeleton** for plugins but **no design-language guidance**. Plugins built from `templates/plugin-python/` render without Mantle tokens, missing meta tags, no postMessage wiring — every author re-derives this from reading hearth's design docs. This FR closes the gap so kindling is the canonical doorway for plugin UI alignment.

## Goals

1. Plugin authors can read **one doc** (`docs/design/plugin-ui-system.md`) and know how to render Mantle-aligned UI: tokens, meta tags, safe-area, postMessage, chrome slots, `@kindling/mantle` imports.
2. New plugins scaffolded from `init-kindling` get tokens + safe-area + theme listener wired by default — no manual copy-paste from hearth.
3. A working `templates/plugin-react/` exists, importing `@kindling/mantle` and demonstrating chrome-slot registration + theme listening.
4. `kindling-consumer` rule (Claude + Cursor mirrored) enforces the UI contract at AI-review time.

## Out of scope

- Authoring `@kindling/mantle` itself — that lives in **hearth FR-0006**.
- Plugin-specific feature work (grocery-list, etc.) — separate FRs in those repos.
- `templates/plugin-python` rewrite to React — keep Python flavor; only the web shell HTML changes.

## Success criteria

- `docs/design/plugin-ui-system.md` exists and is linked from `README.md`, `CLAUDE.md`, and `.cursor/rules/main.mdc`.
- `templates/plugin-python/web/dist/index.html` includes `<meta name="theme-color">`, `viewport-fit=cover`, `:root { --hearth-* }` token wiring, and a code-comment pointing to plugin-ui-system.
- `templates/plugin-react/` exists with `package.json` depending on `@kindling/mantle`, a `<Page>` example with chrome-slot mount, theme listener, and a comment block linking the doc.
- `.claude/rules/kindling-consumer.md` and `.cursor/rules/kindling-consumer.mdc` include a "UI contract" section enforcing tokens-only, no-duplicate-chrome, theme-listener.
- `sync-kindling` consumer test passes (existing template smoke flows still work).

## Partner FRs

- **hearth FR-0006** ships `@kindling/mantle`. Coordinate publish + version pin.
- **grocery-list FR-0002** consumes both. Use grocery-list as the integration smoke test for `templates/plugin-react/`.

## Triage (user-approved 2026-05-21)

**FIX (amend doc inline):** DG-D1 (`plugin-ui-system.md`).
**TAG (ship in DEV stage):** DF-T1 (template tokens), DF-C1 (consumer rule), RW-T1 (plugin-react template).
