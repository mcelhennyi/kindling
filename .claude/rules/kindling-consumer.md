# Kindling consumer rules

Mirrors **`.cursor/rules/kindling-consumer.mdc`**. Keep both files aligned when editing.

This repository is a **Hearth plugin** initialized with the Kindling template layer.
It has two submodules:
- **`.skeleton/`** — process tooling (tickets, AI rules, docs structure)
- **`.kindling/`** — Hearth plugin contract, templates, and plugin-specific rules

## Two-layer setup

| Layer | Submodule | When to sync |
|-------|-----------|-------------|
| Skeleton | `.skeleton/` | `./sync-skeleton` — process/tooling updates |
| Kindling | `.kindling/` | `./sync-kindling` — plugin contract + rule updates |

`./sync-kindling` calls `./sync-skeleton` first. Always read both changelogs after sync.

## Plugin contract

Every file committed in this repo must satisfy the Hearth plugin contract:

- **`tinder.toml`** must be valid against `docs/design/plugin-contract.md` in the Hearth repo.
- **`kind`** must be `"app"` or `"widget"` (no custom kinds in MVP).
- **Backend entrypoint** (`module`) must match the Python package and `create_app()` factory.
- **Spark permissions** (`spark_publish`, `spark_subscribe`, `spark_call`) must be declared;
  no undeclared Spark usage.
- **Persistence** under `var/hearth/plugins/<slug>/` only; no writes outside that path.
- **`plugin` shim** and **`scripts/install`** must remain executable.

## Spark discipline

- Publish only events declared in `[capabilities.*]` or `[permissions].spark_publish`.
- `_try_publish()` / equivalent must skip silently if `HEARTH_SPARK_SOCK` is not set.
- Never call hub internals over HTTP; use Spark only for cross-plugin communication.

## UI contract (DF-C1)

Every plugin with a web UI must satisfy the Mantle design-language contract documented in [`docs/design/plugin-ui-system.md`](../../docs/design/plugin-ui-system.md). At review time, enforce:

- **Tokens only:** plugin CSS reads `--hearth-*` custom properties; no hardcoded brand colors. New status colors live in a plugin-namespaced custom property and are documented.
- **Required meta tags** in the document head: `viewport-fit=cover`, `theme-color` (light + dark via `media` queries), `apple-mobile-web-app-capable=yes`, `apple-mobile-web-app-status-bar-style=black-translucent`.
- **No duplicate shell chrome:** the plugin must not render a second top-fixed title bar that mirrors Mantle's, nor any iframe-bottom-pinned bar. In-frame sticky tab strips, sidebars, and inline toolbars are allowed (see Hearth `plugin-contract.md` § In-frame plugin chrome).
- **Theme listener:** the plugin subscribes to `hearth.theme` postMessage events; on receive it rewrites `:root` tokens and updates the `theme-color` meta tag.
- **`[ui.chrome]` slots:** declared in `tinder.toml` when the plugin mounts shell chrome buttons. Items conform to `ChromeButton` / `ChromeMenu` payload shape; per-plugin caps are top 3, bottom 4, total 8.
- **Overlays via `@kindling/mantle`:** floating dialogs, sheets, and toasts use `<Sheet>` / `<Dialog>` / `<Toast>` so the shell renders them outside iframe clipping.

When `@kindling/mantle` is unavailable (e.g. plain HTML static plugin), the same rules apply by hand — see the worked examples in `templates/plugin-python/web/dist/index.html` and `templates/plugin-react/`.

## Testing

- Run tests inside Docker using the project's compose setup where available.
- Plugin tests use `HEARTH_VAR_DIR` (tmpdir) to isolate SQLite state per test.
- Integration tests requiring a live hub must be gated with `HEARTH_INTEGRATION=1`.

## tinder.toml quick reference

```toml
[plugin]
slug        = "<slug>"
name        = "<Name>"
version     = "0.1.0"
hearth_min  = "0.1.0"
kind        = "app"

[entrypoint]
backend = { kind = "python", module = "<pkg>.app:create_app", port_env = "HEARTH_PLUGIN_PORT" }
ui      = { kind = "static", path = "web/dist" }

[permissions]
spark_publish   = ["<slug>.*"]
spark_subscribe = []
spark_call      = []
fs_paths        = ["plugins/<slug>"]
network         = "loopback"

[backup]
include = ["plugins/<slug>/"]
exclude = ["plugins/<slug>/cache/"]
```
