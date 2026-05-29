# {{ plugin_name }} — React + Mantle UI

Scaffolded from Kindling `templates/plugin-react/`. UI contract: [plugin-ui-system.md](https://github.com/mcelhennyi/kindling/blob/main/docs/design/plugin-ui-system.md).

## Develop

```bash
npm install
npm run dev      # Vite dev server (standalone preview)
npm run build    # emits web/dist/ for tinder.toml static entrypoint
```

Rendered apps depend on `@kindling/mantle` from the Kindling checkout that generated the template, so standalone local development only needs Kindling, not a Hearth checkout. The generated install harness builds local Mantle before installing the app. Published apps may replace that `file:` dependency with the supported `@kindling/mantle` version range required by their target Kindling release.

## Backend

Pair with the Python backend files from `templates/plugin-python/` (copy `{{ python_package }}/`, `plugin`, `scripts/install`, and merge `tinder.toml` sections) or scaffold via `init-kindling --template react --slug {{ plugin_slug }}` from a kindling checkout.
