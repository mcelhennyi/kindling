# @kindling/mantle

Mantle UI primitives, hooks, design tokens, and a vanilla (non-React) bridge for plugins running inside the Hearth shell iframe.

Published from the [kindling](https://github.com/mcelhennyi/kindling) repository (`mantle/`). See [CHANGELOG](./CHANGELOG.md) for release notes.

## Install

```bash
pnpm add @kindling/mantle
# or: npm install @kindling/mantle
```

Requires **React 18+** for the component and hook exports. The vanilla bridge and types work without React.

## Minimal React plugin example

Import styles once in your plugin entry, wrap the app in `MantleProvider`, and use shell-aware hooks:

```tsx
// src/main.tsx
import "@kindling/mantle/styles.css";
import "@kindling/mantle/components.css";

import { MantleProvider, Page, PageHeader, Card, Button, useTheme } from "@kindling/mantle";

function GroceriesHome() {
  const { theme } = useTheme();
  return (
    <Page>
      <PageHeader title="Groceries" />
      <Card>
        <p>Current theme: {theme.mode}</p>
        <Button variant="accent">Add item</Button>
      </Card>
    </Page>
  );
}

export function App() {
  return (
    <MantleProvider>
      <GroceriesHome />
    </MantleProvider>
  );
}
```

For the full plugin UI contract (chrome slots, frame states, overlay escape, non-React plugins), see Kindling's **[Plugin UI system](https://github.com/mcelhennyi/kindling/blob/main/docs/design/plugin-ui-system.md)** design doc. Hearth shell behavior is specified in [`docs/design/mantle-ui.md`](../../docs/design/mantle-ui.md).

## Exports

| Import path | Purpose |
|-------------|---------|
| `@kindling/mantle` | React components, hooks, `MantleProvider`, bridge helpers |
| `@kindling/mantle/styles.css` | Design tokens (`--hearth-*`) |
| `@kindling/mantle/components.css` | Component layout and variants |
| `@kindling/mantle/vanilla` | `mantle.theme` and `mantle.chrome` for non-React plugins |
| `@kindling/mantle/vanilla/mantle.iife` | Script-tag IIFE bundle |
| `@kindling/mantle/types` | Pure TypeScript types (no runtime) |

## Vanilla (non-React) snippet

```html
<link rel="stylesheet" href="/node_modules/@kindling/mantle/src/tokens.css" />
<script src="/node_modules/@kindling/mantle/dist/vanilla/mantle.iife.js"></script>
<script>
  mantle.theme.subscribe(({ tokens }) => {
    document.documentElement.style.setProperty("--hearth-bg", tokens.bg);
  });
  mantle.chrome.mount({ slot: "top", items: [{ kind: "button", id: "add", label: "Add" }] });
</script>
```

## Build from source

```bash
pnpm --filter @kindling/mantle build
pnpm --filter @kindling/mantle test
pnpm --filter @kindling/mantle pack:dry-run
```

In a Hearth checkout during FR-0007 migration, run Mantle package commands from the Kindling submodule path, for example `cd kindling/mantle && pnpm run test`, after installing package dependencies in the chosen container or local development environment.

## Packaging (maintainers)

This package is **private for now**. Do not configure an npm publishing token or publish it to the public registry until the project records an explicit publish policy change.

Versioning is **manual** — bump `version` in `package.json` and add a [CHANGELOG](./CHANGELOG.md) entry before cutting any private package artifact.

1. Merge Mantle changes to the Kindling integration branch and confirm **kindling-mantle CI** is green.
2. Run `pnpm --filter @kindling/mantle pack:dry-run` and inspect the tarball contents.
3. Use a local/private package path for partner repos until publish policy changes.

## Authoritative design docs

- Shell + iframe contract: [Hearth `mantle-ui.md`](https://github.com/mcelhennyi/hearth/blob/main/docs/design/mantle-ui.md)
- Plugin UI system (Kindling): [`docs/design/plugin-ui-system.md`](../docs/design/plugin-ui-system.md)
- Original package feature history: [Hearth `FR-0006-design-language`](https://github.com/mcelhennyi/hearth/tree/main/tasks/feature-history/FR-0006-design-language/)

## License

MIT — see [`LICENSE`](./LICENSE).
