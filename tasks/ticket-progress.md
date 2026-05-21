# Ticket progress

## Current focus

| Field | Value |
|-------|--------|
| **Active ticket** | — (FR-0001 design stage) |
| **Active phase** | design |
| **Branch / worktree** | `main` |
| **Session status** | `planning` |
| **Next agent should** | Author `10-design-00-skeleton.md` for FR-0001, then `20-tickets-dag.md`, promote to `tickets.md`. Coordinate with hearth FR-0006 (`@kindling/mantle` ship) and grocery-list FR-0002 (consumer). |

### Parallel streams

| Stream label | Ticket(s) | `FR-NNNN` | Branch / worktree | Owner / note |
|----------------|------------|-----------|-------------------|--------------|
| design-language unification | — (design stage) | FR-0001 | `main` | Cross-repo: hearth FR-0006 + grocery-list FR-0002 |

---

## Progress

| Ticket | Title | TEST | DEV | VAL | Notes |
|--------|-------|------|-----|-----|-------|
| T-FR-0001-01 | Python template tokens + meta + theme listener | — | — | — | `FR-0001` **design**. DF-T1. Deps: none. |
| T-FR-0001-02 | React plugin template scaffold | — | — | — | `FR-0001` **design**. RW-T1. Cross-repo soft-dep: hearth T-FR-0006-15. |
| T-FR-0001-03 | `init-kindling --template` flag | — | — | — | `FR-0001` **design**. Deps: T-FR-0001-01, T-FR-0001-02. |
| T-FR-0001-04 | Template smoke + sync regression | — | — | — | `FR-0001` **design**. Deps: T-FR-0001-01..03. |
