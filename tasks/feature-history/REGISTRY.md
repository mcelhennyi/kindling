# Feature request registry (`FR-NNNN`)

**Rules:** Four-digit zero-padded ids. **Never** reuse an **`FR-NNNN`** for a different feature. Increment **`next_id`** when allocating a new number.

**Parallel features:** Multiple rows may be **`design`** or **`in-progress`** at the same time. Each row points at a distinct directory `tasks/feature-history/FR-NNNN-<slug>/`.

| FR id | Slug (directory) | Status | Tickets (when known) | Notes |
|-------|------------------|--------|------------------------|-------|
| FR-0000 | `FR-0000-bootstrap/` | `done` | — | Skeleton consumer + Hearth plugin template layer established. Commit `0b83879` (2026-05-20). No tickets — bootstrapped directly. |
| FR-0001 | `FR-0001-plugin-ui-system/` | `design` | TBD — see [`tickets.md`](FR-0001-plugin-ui-system/tickets.md) once authored | Plugin-author design-language layer: author `docs/design/plugin-ui-system.md`, replace bare template, add `templates/plugin-react/`, extend `kindling-consumer` rule. Consumes **`@kindling/mantle`** shipped by hearth FR-0006. |

**next_id:** `2`

**Allocating a new `FR-NNNN`:** Create directory `tasks/feature-history/FR-NNNN-<slug>/`, add a row to the table, set `next_id` to NNNN+1, and add the ticket file path to `TICKET-SOURCES.md`.
