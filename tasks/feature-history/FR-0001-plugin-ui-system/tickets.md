# FR-0001 — Tickets

**Feature:** FR-0001 `plugin-ui-system` · **next_xx:** `5`

DAG: [`20-tickets-dag.md`](20-tickets-dag.md).

---

### T-FR-0001-01 — Python template tokens + meta + theme listener

**Type:** impl · **Deps:** none · **Order:** P0 · **Owner:** —

Replace the bare `templates/plugin-python/web/dist/index.html` with a Mantle-aligned shape (closes `DF-T1`). See [`10-design-00-skeleton.md`](10-design-00-skeleton.md) for the exact HTML/CSS/JS structure.

**Phases**

| Phase | Acceptance |
|-------|------------|
| **TEST** | Add a smoke test under `scripts/tests/` (or equivalent) that parses the rendered template after `init-kindling` and asserts: required meta tags present, `:root` declares all `--hearth-*` tokens, theme listener is wired with origin check. |
| **DEV** | Replace the template HTML. Tokens defined in `<style>` block (no external file at this stage — keeps the static plugin path single-file). |
| **VAL** | Existing kindling tests + new template smoke pass. Manual: scaffold a fresh plugin via `init-kindling` and verify the resulting `web/dist/index.html` matches. |

---

### T-FR-0001-02 — React plugin template scaffold

**Type:** impl · **Deps:** none (cross-repo soft-dep: hearth T-FR-0006-15 for npm publish) · **Order:** P1 · **Owner:** —

Add a new `templates/plugin-react/` scaffold (closes `RW-T1`).

**Surface**

```
templates/plugin-react/
├── package.json           # @kindling/mantle, react, react-dom, vite
├── vite.config.ts         # outDir: web/dist; base: '/'
├── tsconfig.json
├── index.html
├── src/main.tsx
├── src/App.tsx            # <Page> + useTheme + useChromeSlot demo
├── tinder.toml.template   # includes commented [ui.chrome]
└── README.md
```

`@kindling/mantle` is pinned via npm; until hearth FR-0006-15 publishes v0.1.0, the template pins a path/workspace reference and documents the switch in its README.

**Phases**

| Phase | Acceptance |
|-------|------------|
| **TEST** | Smoke that `npm install` + `npm run build` in the rendered template produce `web/dist/index.html` with the expected tokens and a working `App.tsx` bundle. Skippable in CI when offline; run gated by `KINDLING_NETWORK_TESTS=1`. |
| **DEV** | Template tree + Vite config. |
| **VAL** | Smoke test passes (gated). Manual: `init-kindling --template react` scaffolds a runnable plugin. |

---

### T-FR-0001-03 — `init-kindling --template` flag

**Type:** impl · **Deps:** T-FR-0001-01, T-FR-0001-02 · **Order:** P2 · **Owner:** —

Extend the scaffolder so users pick a template.

**Surface**

- `init-kindling [--template python|react] [other flags]`. Default `python`.
- When omitted, prompt interactively (TTY only); non-TTY uses default.
- Template path resolves to `templates/plugin-<choice>/`.

**Phases**

| Phase | Acceptance |
|-------|------------|
| **TEST** | Unit test the arg parsing; both template paths resolve; unknown value rejected. |
| **DEV** | Update `init-kindling` script; update README. |
| **VAL** | Manual scaffold of each template via CLI. |

---

### T-FR-0001-04 — Template smoke + sync-kindling regression

**Type:** impl · **Deps:** T-FR-0001-01, T-FR-0001-02, T-FR-0001-03 · **Order:** P2 · **Owner:** —

Add a smoke test that both templates pass `kindling validate` and produce a runnable artifact after `init-kindling`. Ensure `sync-kindling` consumer flow (template copy into a consumer repo) still works.

**Phases**

| Phase | Acceptance |
|-------|------------|
| **TEST** | Smoke covers: scaffold → install deps (gated) → build → manifest validate → assert tokens in built HTML. |
| **DEV** | Test scaffolding under `scripts/tests/templates/`. |
| **VAL** | Test passes in CI (skipped/gated portions documented). |
