# FR-0001 — Serial diary

## 2026-05-21 — Stage 0: bootstrap + intake

- Bootstrapped kindling FR workflow: `tasks/feature-history/`, `tasks/TAG-REGISTRY.md`, `tasks/ticket-progress.md`, retroactive `FR-0000-bootstrap` entry.
- Allocated **FR-0001 `plugin-ui-system`**.
- Reserved tag ids: **DG-D1, DF-T1, DF-C1, RW-T1**.
- Authored `README.md`, `00-intake.md`.
- Cross-FR pairing: depends on **hearth FR-0006** (`@kindling/mantle` package); integrates with **grocery-list FR-0002** (consumer).
- **Next:** push to `origin/main`, then author `docs/design/plugin-ui-system.md` (the FIX item), then layered design + tickets.

## 2026-05-21 — Stage 1: docs + Stage 2: tickets

- Authored `docs/design/plugin-ui-system.md` (closes `DG-D1`); extended `.claude/rules/kindling-consumer.md` + `.cursor/rules/kindling-consumer.mdc` with UI contract section (closes `DF-C1`). Commit `f34cb98`.
- Authored `10-design-00-skeleton.md`, `20-tickets-dag.md`, `tickets.md` with `T-FR-0001-01..04`.
- Updated `tasks/ticket-progress.md` and `TICKET-SOURCES.md`.
- **Next:** push, then grocery-list FR-0002 tickets, then present develop-or-stop.
