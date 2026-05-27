# {{ plugin_name }} — React + Mantle UI

Scaffolded from Kindling `templates/plugin-react/`. UI contract: [plugin-ui-system.md](https://github.com/mcelhennyi/kindling/blob/main/docs/design/plugin-ui-system.md).

## Develop

```bash
npm install
npm run dev      # Vite dev server (standalone preview)
npm run build    # emits web/dist/ for tinder.toml static entrypoint
```

`@kindling/mantle` is pinned at `^0.1.0` from Kindling `mantle/`. For local work before a registry publish, set `KINDLING_MANTLE_PATH` to the Kindling mantle package directory when running template smoke tests.

## Backend

Pair with the Python backend files from `templates/plugin-python/` (copy `{{ python_package }}/`, `plugin`, `scripts/install`, and merge `tinder.toml` sections) or scaffold via `init-kindling --template react --slug {{ plugin_slug }}` from a kindling checkout.
