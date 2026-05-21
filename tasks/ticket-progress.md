# Ticket progress

## Current focus

| Field | Value |
|-------|--------|
| **Active ticket** | T-FR-0001-01 (W0) |
| **Active phase** | TEST/DEV/VAL in flight |
| **Branch / worktree** | `feat/FR-0001-plugin-ui-system` @ `.worktrees/FR-0001-plugin-ui-system/feature/`; ticket worktree `feat/FR-0001-plugin-ui-system-T-FR-0001-01-python-template` @ `.worktrees/FR-0001-plugin-ui-system/T-FR-0001-01-python-template/` |
| **Session status** | `developing` |
| **Next agent should** | Follow `parallel/T-FR-0001-01-python-template.md` diary. When VAL-done, merge into `feat/FR-0001-plugin-ui-system`. T-FR-0001-02 stays pending until hearth T-FR-0006-15 publishes `@kindling/mantle`. |

### Parallel streams

| Stream label | Ticket(s) | `FR-NNNN` | Branch / worktree | Owner / note |
|----------------|------------|-----------|-------------------|--------------|
| W0/kindling-python-template | T-FR-0001-01 | FR-0001 | `feat/FR-0001-plugin-ui-system-T-FR-0001-01-python-template` @ `.worktrees/FR-0001-plugin-ui-system/T-FR-0001-01-python-template/` | parallel subagent. Cross-repo: hearth FR-0006, grocery FR-0002. |

---

## Progress

| Ticket | Title | TEST | DEV | VAL | Notes |
|--------|-------|------|-----|-----|-------|
| T-FR-0001-01 | Python template tokens + meta + theme listener | — | — | — | `FR-0001` **design**. DF-T1. Deps: none. |
| T-FR-0001-02 | React plugin template scaffold | — | — | — | `FR-0001` **design**. RW-T1. Cross-repo soft-dep: hearth T-FR-0006-15. |
| T-FR-0001-03 | `init-kindling --template` flag | — | — | — | `FR-0001` **design**. Deps: T-FR-0001-01, T-FR-0001-02. |
| T-FR-0001-04 | Template smoke + sync regression | — | — | — | `FR-0001` **design**. Deps: T-FR-0001-01..03. |
