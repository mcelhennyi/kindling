# Handoff — pause before develop (FR-0001)

**Date:** 2026-05-21 · **Status:** design complete, paused before implementation · **No closeout** (feature is not complete).

## Where we are

- `docs/design/plugin-ui-system.md` authored (closes `DG-D1`); `kindling-consumer` rule + `.cursor` mirror extended with UI contract (closes `DF-C1`). Commit `f34cb98`.
- FR-0001 design skeleton, DAG, tickets (`T-FR-0001-01..04`) authored. Commit `f131bc8`.
- Tag reservations pushed (`DG-D1`, `DF-T1`, `DF-C1`, `RW-T1`).

## Why we paused

User validates the cross-repo plan before any implementation begins. Resume is **manual** via `/feature-request-continue`.

## Resume contract — what to do when restarted

When the user runs `/feature-request-continue` (in this repo or via the projects-root coordinator), execute the following **without re-asking** the develop-or-stop decision:

1. **Verify nothing has shifted on `main`:** `git fetch && git log --oneline origin/main ^HEAD || true`. If anything beyond `f131bc8` appears, summarise it before acting.
2. **Create the feature integration worktree:** `git worktree add .worktrees/FR-0001-plugin-ui-system/feature feat/FR-0001-plugin-ui-system`. Initialise repo-root `CURRENT.md` on that branch.
3. **Update `tasks/ticket-progress.md` → Current focus + Parallel streams:** Active ticket `T-FR-0001-01`; Session status `developing`; Parallel streams row for FR-0001.
4. **Launch `/develop-frontier`** for **`T-FR-0001-01`** (Python template tokens + theme listener) as this repo's W0 work. The cross-repo W0 spans 6 subagents total — see hearth FR-0006 handoff [`2026-05-21-pause-before-develop.md`](https://github.com/mcelhennyi/hearth/blob/main/tasks/feature-history/FR-0006-design-language/handoffs/2026-05-21-pause-before-develop.md) for the full slate.
5. **Cross-repo dependency:** `T-FR-0001-02` (React template) soft-depends on hearth `T-FR-0006-15` (npm publish). Until that lands, T-FR-0001-02 stays pending; it does **not** block T-FR-0001-01.

## Out of scope on resume

- Do **not** open the default-branch PR until **§2d feature-complete gate** is met.
- Do **not** write `90-closeout.md` until feature-complete.
- Do **not** delete remote `feat/*` branches at any point.

## Executive summary

Design closed; tickets ready; W0 single-ticket start (`T-FR-0001-01`) authorised for next session, as part of the cross-repo full-W0 fan-out.

## Suggested next step (for the resuming agent)

Run `/feature-request-continue` here, then execute the **Resume contract** steps above without further prompts.
