# FR-0001 — Design skeleton (L0)

Public surfaces only. Behavior lives in [`docs/design/plugin-ui-system.md`](../../../docs/design/plugin-ui-system.md) (already authored; FIX-tier doc commit `f34cb98`).

## Template `web/dist/index.html` (Python)

Closes `DF-T1`. New shape:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport"
        content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <meta name="theme-color" content="#0f1115" media="(prefers-color-scheme: dark)" />
  <meta name="theme-color" content="#fafafa" media="(prefers-color-scheme: light)" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
  <title>{{ plugin_name }}</title>
  <style>
    :root { /* full --hearth-* token set, light + dark via media query */ }
    body { background: var(--hearth-bg); color: var(--hearth-fg); font-family: var(--hearth-font-sans); padding: var(--hearth-safe-top) 16px var(--hearth-safe-bottom); }
  </style>
</head>
<body>
  <h1>{{ plugin_name }}</h1>
  <p>See <a href="https://github.com/mcelhennyi/kindling/blob/main/docs/design/plugin-ui-system.md">plugin-ui-system.md</a>.</p>
  <script>
    // Minimal theme listener (vanilla; mirrors @kindling/mantle/vanilla/theme.ts).
    window.addEventListener("message", (e) => {
      if (e.origin !== window.location.origin) return;
      const m = e.data;
      if (m?.type === "hearth.theme") {
        for (const [k, v] of Object.entries(m.tokens || {})) {
          document.documentElement.style.setProperty(k, v);
        }
        const meta = document.querySelector('meta[name="theme-color"]:not([media])')
          || document.head.appendChild(Object.assign(document.createElement("meta"), { name: "theme-color" }));
        meta.setAttribute("content", m.tokens?.["--hearth-bg"] || "");
      }
    });
  </script>
</body>
</html>
```

## Template `plugin-react/` (new)

Closes `RW-T1`. Files:

```
templates/plugin-react/
├── package.json            # @kindling/mantle, react, vite as deps
├── vite.config.ts
├── tsconfig.json
├── index.html              # same <head> shape as plugin-python
├── src/
│   ├── main.tsx            # ReactDOM root
│   └── App.tsx             # <Page><PageHeader title={…}/>…</Page>, useTheme(), useChromeSlot demo
├── tinder.toml.template    # adds [ui.chrome] example commented out
└── README.md               # quickstart + link to plugin-ui-system.md
```

Pins `@kindling/mantle` from hearth FR-0006-15.

## `init-kindling` extension

Add `--template python|react` (default `python`). Surface in scripts under `init-kindling`.

## `kindling-consumer` rule UI contract section

**Already landed** in commit `f34cb98`. No further changes.

## Out of scope

- React Native or any non-web template.
- TypeScript-only Python plugin (still ships JS in `web/dist/`).
- Storybook for the kindling templates.
