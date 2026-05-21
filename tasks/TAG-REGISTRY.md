# Tag registry

**Authority:** Allocate durable numbered ids here before use in design docs, code traceability, or handoffs. **Commit and push to the default branch before** placing ids in prose (see `.cursor/rules/tag-reservation.mdc`).

**Traceability prefix:** `@KDL-<AREA>-<n>` in code.

## Area letters

| Letter | Area | Typical owning paths |
|--------|------|----------------------|
| **D** | Plugin design language (tokens, components, postMessage contract for plugin authors) | `docs/design/plugin-ui-system.md` |
| **T** | Plugin templates (`plugin-python`, future `plugin-react`) | `templates/` |
| **C** | Kindling-consumer contract rules | `.claude/rules/kindling-consumer.md`, `.cursor/rules/kindling-consumer.mdc` |
| **B** | Build, sync scripts, CLI | `scripts/`, `sync-kindling`, `init-kindling` |

Define new letters here and in `docs/design/documentation-style.md` (when authored) before first use.

---

## Design gaps (`DG-`)

| Id | Area | Status | Date | Intent | Owning doc(s) |
|----|------|--------|------|--------|----------------|
| DG-D1 | D | allocated | 2026-05-21 | Missing `docs/design/plugin-ui-system.md` — plugin authors have no doc telling them how to consume Mantle tokens, components, postMessage contract | `docs/design/plugin-ui-system.md` (to be authored under FR-0001) |

**Next free:** DG-D2, DG-T1, DG-C1, DG-B1, …

---

## Design flaws (`DF-`)

| Id | Status | Date | Intent | Owning doc(s) |
|----|--------|------|--------|----------------|
| DF-T1 | allocated | 2026-05-21 | Template `templates/plugin-python/web/dist/index.html` lacks Mantle tokens, `viewport-fit=cover`, `theme-color` meta, safe-area handling | `templates/plugin-python/web/dist/index.html` |
| DF-C1 | allocated | 2026-05-21 | `kindling-consumer` rule does not enforce a UI contract (tokens, no duplicate chrome, theme listener) | `.claude/rules/kindling-consumer.md`, `.cursor/rules/kindling-consumer.mdc` |

---

## Rework required (`RW-`)

| Id | Area | Status | Date | Intent | Deviating artifact(s) |
|----|------|--------|------|--------|------------------------|
| RW-T1 | T | allocated | 2026-05-21 | No `templates/plugin-react/` variant demonstrating Mantle integration (tokens, hooks, chrome slots, theme listener) | `templates/` |

---

## Growth (`GR-`)

| Id | Area | Status | Date | Intent | monitor |
|----|------|--------|------|--------|---------|
| *(none)* | — | — | — | — | — |

---

## Refinements (`R-`)

| Id | Area | Status | Date | Intent | Owning doc(s) |
|----|------|--------|------|--------|----------------|
| *(none)* | — | — | — | — | — |

---

## Decisions (`DEC-`)

| Id | Status | Date | Intent | Owning doc(s) |
|----|--------|------|--------|----------------|
| *(none)* | — | — | — | — |

---

## Trade studies (`TS-`)

| Id | Status | Date | Intent | Owning doc(s) |
|----|--------|------|--------|----------------|
| *(none)* | — | — | — | — |

---

## Features (`FR-NNNN`)

Canonical list: `tasks/feature-history/REGISTRY.md`. Summary only:

| Id | Status | Slug |
|----|--------|------|
| FR-0000 | done | bootstrap |
| FR-0001 | design | plugin-ui-system |
