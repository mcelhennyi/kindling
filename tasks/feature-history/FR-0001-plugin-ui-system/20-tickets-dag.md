# FR-0001 — Tickets DAG (draft)

Canonical bodies in [`tickets.md`](tickets.md).

## Ticket table

| Id | Title | Type | Deps | Order | Summary |
|----|-------|------|------|-------|---------|
| T-FR-0001-01 | Python template tokens + meta + theme listener | impl | none | P0 | Replace `templates/plugin-python/web/dist/index.html` with the Mantle-aligned shape. DF-T1. |
| T-FR-0001-02 | React plugin template scaffold | impl | none (cross-repo: hearth T-FR-0006-15 for runtime publish) | P1 | New `templates/plugin-react/` with `@kindling/mantle` pinned (workspace ref until hearth publish). RW-T1. |
| T-FR-0001-03 | `init-kindling --template` flag | impl | 01, 02 | P2 | Wire CLI choice between python/react templates. |
| T-FR-0001-04 | Template smoke + sync-kindling regression | impl | 01, 02, 03 | P2 | Add a smoke test that both templates pass `kindling validate` and produce a runnable bundle. |

## Mermaid DAG

```mermaid
flowchart TD
  classDef p0 fill:#fde68a,color:#000
  classDef p1 fill:#bfdbfe,color:#000
  classDef p2 fill:#c7d2fe,color:#000

  T01["Python template tokens + theme listener (T-FR-0001-01)"]:::p0
  T02["React plugin template scaffold (T-FR-0001-02)"]:::p1
  T03["init-kindling --template flag (T-FR-0001-03)"]:::p2
  T04["Template smoke + sync regression (T-FR-0001-04)"]:::p2

  T01 --> T03
  T02 --> T03
  T01 --> T04
  T02 --> T04
  T03 --> T04
```

## Cross-repo dependency

- **T-FR-0001-02** uses `@kindling/mantle`. Until **hearth T-FR-0006-15** publishes v0.1.0 to npm, the template pins a `workspace:*` or pre-release path in its `package.json`. Switch to the published version in the same commit that closes the dep.

## Parallel waves

| Wave | Tickets |
|------|---------|
| W0 | T01, T02 |
| W1 | T03 |
| W2 | T04 |
