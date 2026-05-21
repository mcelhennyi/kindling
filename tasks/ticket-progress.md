# Ticket progress

## Current focus

| Field | Value |
|-------|--------|
| **Active ticket** | — (FR-0001 design stage) |
| **Active phase** | design |
| **Branch / worktree** | `main` |
| **Session status** | `planning` |
| **Next agent should** | **FR-0001 design is complete and paused before implementation** — see [`FR-0001-plugin-ui-system/handoffs/2026-05-21-pause-before-develop.md`](feature-history/FR-0001-plugin-ui-system/handoffs/2026-05-21-pause-before-develop.md). On `/feature-request-continue`, execute its Resume contract (creates `feat/FR-0001-plugin-ui-system` worktree; launches `/develop-frontier` for `T-FR-0001-01` as part of the cross-repo W0 fan-out). |

### Parallel streams

| Stream label | Ticket(s) | `FR-NNNN` | Branch / worktree | Owner / note |
|----------------|------------|-----------|-------------------|--------------|
| plugin-ui-system (paused before develop) | T-FR-0001-01..04 (design) | FR-0001 | `main` (no feature worktree yet) | Resume contract: [`handoffs/2026-05-21-pause-before-develop.md`](feature-history/FR-0001-plugin-ui-system/handoffs/2026-05-21-pause-before-develop.md). Cross-repo: hearth FR-0006, grocery FR-0002. |

---

## Progress

| Ticket | Title | TEST | DEV | VAL | Notes |
|--------|-------|------|-----|-----|-------|
| T-FR-0001-01 | Python template tokens + meta + theme listener | — | — | — | `FR-0001` **design**. DF-T1. Deps: none. |
| T-FR-0001-02 | React plugin template scaffold | — | — | — | `FR-0001` **design**. RW-T1. Cross-repo soft-dep: hearth T-FR-0006-15. |
| T-FR-0001-03 | `init-kindling --template` flag | — | — | — | `FR-0001` **design**. Deps: T-FR-0001-01, T-FR-0001-02. |
| T-FR-0001-04 | Template smoke + sync regression | — | — | — | `FR-0001` **design**. Deps: T-FR-0001-01..03. |
