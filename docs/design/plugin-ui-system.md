# Plugin UI system

**Authority:** This document is the **kindling-side** entry point for plugin authors who want their Hearth plugin to render with Mantle-aligned UI. The **logical and visual source of truth** is in the Hearth repo — see [Hearth `mantle-ui.md`](https://github.com/mcelhennyi/hearth/blob/main/docs/design/mantle-ui.md) and [`plugin-contract.md`](https://github.com/mcelhennyi/hearth/blob/main/docs/design/plugin-contract.md). This doc tells you **what kindling gives you to satisfy that contract**, and where the boundaries are.

> **`DG-D1` closed 2026-05-21.** Authored as part of FR-0001 (plugin-ui-system).

## Why this doc exists

A Hearth plugin's web UI runs inside the Mantle shell's iframe. To feel like one app with the rest of Hearth, the plugin must:

1. Use **Hearth design tokens** for color, type, spacing, radius.
2. Set the right **meta tags** so iOS PWAs render without browser chrome.
3. Speak the **postMessage protocol** so theme, title, navigation, and chrome slots stay in sync with the shell.
4. **Not** render duplicate shell chrome (a second top/bottom bar that competes with Mantle's).

Without this doc, every plugin author re-derives those facts from reading hearth's repo. With it, scaffolding from kindling (`init-kindling`) wires the contract by default and this doc records the rules.

## The shipped surface

| Layer | Where it lives | What it is |
|-------|----------------|------------|
| Design tokens | `@kindling/mantle/tokens` | The `--hearth-*` CSS custom properties (color, type, spacing, radius, safe-area). Mirrors Hearth `mantle-ui.md` §Theme tokens. |
| Base components | `@kindling/mantle` (React) | `<Page>`, `<PageHeader>`, `<Card>`, `<Section>`, `<List>`, `<EmptyState>`, `<Button>`, `<IconButton>`, `<Input>`, `<TextArea>`, `<Select>`, `<Switch>`, `<Sheet>`, `<Toast>`, `<Dialog>`. |
| Hooks | `@kindling/mantle` (React) | `useMantle()`, `useUser()`, `useTheme()`, `useSpark()`, `useHaptics()`, `useNotifications()`, `useChromeSlot()`. |
| Vanilla bridge | `@kindling/mantle/vanilla` | Imperative `mantle.theme.subscribe()`, `mantle.chrome.mount()`, etc. for non-React plugins. |

The package is **authored in hearth** (FR-0006) and consumed via npm. Kindling templates pin a version per its `templates/plugin-react/package.json`.

> **Status (2026-05-27):** `@kindling/mantle` **v0.1.0** source now lives in Kindling `mantle/` after Hearth FR-0007 moved the FR-0006 private package out of Hearth's `packages/mantle/`. The React template pins `^0.1.0`; the Python template's `web/dist/index.html` includes inline `--hearth-*` tokens and a vanilla theme listener.

## Required `<head>` for every plugin

Whether you ship a React app or a single static HTML page, the document head must include:

```html
<meta charset="utf-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#0f1115" media="(prefers-color-scheme: dark)">
<meta name="theme-color" content="#fafafa" media="(prefers-color-scheme: light)">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<link rel="stylesheet" href="/path/to/your/css">
```

- **`viewport-fit=cover`** is required so iOS PWAs respect the safe-area inset variables.
- **`theme-color`** must match the active token (`--hearth-bg` light/dark). The shell pushes theme changes via `hearth.theme`; update the meta tag in your theme listener so the iOS status bar follows.
- **`apple-mobile-web-app-*`** keeps the plugin chrome-free when launched standalone (relevant for direct-link plugin testing; in production the plugin loads inside the shell iframe).

## Required `:root` tokens

The plugin's stylesheet must define (or inherit, via `@kindling/mantle/tokens`) the full token set so the shell's `hearth.theme` push has somewhere to write. Minimum:

```css
:root {
  --hearth-bg: #0f1115;
  --hearth-surface: #161a22;
  --hearth-fg: #e6e6e6;
  --hearth-muted: #9aa3b2;
  --hearth-accent: #ff6a3d;
  --hearth-accent-fg: #0f1115;
  --hearth-error: #ff6b6b;
  --hearth-radius-sm: 4px;
  --hearth-radius-md: 8px;
  --hearth-radius-lg: 16px;
  --hearth-font-sans: -apple-system, Inter, system-ui, sans-serif;
  --hearth-safe-top: env(safe-area-inset-top);
  --hearth-safe-bottom: env(safe-area-inset-bottom);
}

@media (prefers-color-scheme: light) {
  :root {
    --hearth-bg: #fafafa;
    --hearth-surface: #ffffff;
    --hearth-fg: #111111;
    --hearth-muted: #6b7280;
    --hearth-accent-fg: #ffffff;
    --hearth-error: #e53935;
  }
}
```

**Hardcoded brand colors are forbidden** in plugin UI. If you need a status color the tokens do not provide, add it inside your plugin's namespace (`--myplugin-status-warning`) and document the choice.

## postMessage protocol — what your plugin must do

The shell ↔ plugin contract is defined in [Hearth `mantle-ui.md` § postMessage protocol](https://github.com/mcelhennyi/hearth/blob/main/docs/design/mantle-ui.md#postmessage-protocol-shell--plugin-iframe). Kindling's React template wires these through `useMantle()`. For non-React plugins, use `@kindling/mantle/vanilla`.

### Minimum your plugin should handle

| When | Action |
|------|--------|
| Plugin mounts | Subscribe to `message` events; filter to `event.origin === window.location.origin`; only act on `event.data?.type?.startsWith("hearth.")`. |
| Receive `hearth.theme` | Re-write `:root` token vars to match `tokens`; update `theme-color` meta tag to the new `--hearth-bg`. |
| Receive `hearth.user` | Store user info; display avatar / name if relevant. |
| Receive `hearth.online` | Reflect connectivity in the UI; pause polling when offline. |
| Set page title | `parent.postMessage({type:"hearth.title", title}, window.location.origin)` — sets browser tab title and Mantle top-bar title. |
| Mount chrome slot | `parent.postMessage({type:"hearth.chrome.mount", slot:"top", surface:"my-actions", payload:{kind:"button", id:"add", label:"Add", icon:"plus", variant:"accent"}}, ...)`. See Slot rules below. |
| Receive `hearth.chrome.invoke` | Plugin acts on the user activation (e.g. open a sheet). |

### Slot rules (mirrors hearth `mantle-ui.md` § Declaring chrome slots)

- Declare your slot intent in `tinder.toml` `[ui.chrome]` so the shell allocates DOM zones up front:
  ```toml
  [ui.chrome]
  top    = { slots = ["actions"] }
  bottom = { slots = ["primary"] }
  ```
- Each `slot` accepts payloads of shape `ChromeButton` or `ChromeMenu` (see hearth spec).
- **Caps:** at most 3 items visible on `top`, 4 on `bottom` per plugin; excess collapse into a `⋯` overflow menu. Total per slot ≤ 8.
- Use the same `id` to update an item (replace, not duplicate). `hearth.chrome.unmount` removes it.
- The shell auto-unmounts everything when the user leaves your route.

## In-frame chrome you may render (per hearth `plugin-contract.md` DG-T1)

| Shape | Allowed? |
|-------|----------|
| Sticky tab bar at the iframe's top (e.g. `position: sticky; top: 0`) | **Yes** |
| Sidebar on desktop (≥768 px) inside your iframe | **Yes** |
| Inline toolbars (search, filter rows under the page title) | **Yes** |
| Floating dialog / sheet / toast that visually escapes the iframe | **Yes, but only via `<Sheet>` / `<Dialog>` / `<Toast>` from `@kindling/mantle`** — they route through postMessage so the shell renders the overlay outside iframe clipping bounds. |
| A second full-width title bar that mirrors the shell's top bar | **No** — competes with Mantle chrome. |
| An iframe-side bar pinned to the bottom of the iframe | **No** — that space is the shell's bottom-bar `[ui.chrome].bottom`. |

## Safe area handling

The shell sets `viewport-fit=cover` on the host page; the iframe inherits a viewport whose safe-area insets reflect the device chrome (notch, home indicator). Your plugin **must** use `env(safe-area-inset-*)` (or the `--hearth-safe-top/bottom` tokens) for any element pinned to the top or bottom of the iframe. The shell's `<Page>` component does this for you automatically when you wrap your page.

## Template variants

| Template | Use when |
|----------|----------|
| `templates/plugin-python` | The plugin is mostly backend; the UI is a single static page. The template's `web/dist/index.html` ships the tokens inline and a small theme listener. |
| `templates/plugin-react` *(FR-0001 deliverable)* | The plugin has a non-trivial UI. Vite + React + `@kindling/mantle` preinstalled; `<Page>` + theme listener already wired. Use this as the integration smoke test for `@kindling/mantle`. |

`init-kindling` will be extended to ask for the template at scaffold time.

## Don'ts

- **Don't** import design tokens from the hearth repo as relative paths or vendored copies — depend on `@kindling/mantle/tokens`.
- **Don't** call `window.parent.postMessage` without an origin check; iframe parent origin is `window.location.origin` (Hearth proxy is same-origin per route).
- **Don't** render a sign-in / sign-out flow inside the plugin; Mantle owns the user session.
- **Don't** disable scroll on the iframe body; the shell relies on the iframe's own scroll for content overflow.
- **Don't** ship hardcoded brand colors. Use tokens; if a token is missing, propose it via a Hearth `DESIGN-GAP` before adding a plugin-namespaced override.

## Verifying

Before shipping a plugin's UI:

1. Run inside the Hearth Mantle shell on **mobile** (iPhone PWA) and **desktop** (≥768 px). Both viewports must render without horizontal scroll.
2. Toggle theme in Settings → Theme — your UI must repaint without reload.
3. Trigger `Sign out` — your UI must not reappear with stale data; the shell will re-mount after re-auth.
4. Run `npm run build` (React template) or your equivalent; the resulting bundle must serve correctly from `tinder.toml`'s `entrypoint.ui.path`.

## See also

- [Hearth `mantle-ui.md`](https://github.com/mcelhennyi/hearth/blob/main/docs/design/mantle-ui.md) — logical contract, tokens, postMessage details.
- [Hearth `plugin-contract.md`](https://github.com/mcelhennyi/hearth/blob/main/docs/design/plugin-contract.md) — Tinder manifest schema; `[ui.chrome]` and `[ui.nav]`.
- [Hearth `dashboard.md`](https://github.com/mcelhennyi/hearth/blob/main/docs/design/dashboard.md) — when your plugin contributes a widget surface.
- [`.claude/rules/kindling-consumer.md`](../../.claude/rules/kindling-consumer.md) / [`.cursor/rules/kindling-consumer.mdc`](../../.cursor/rules/kindling-consumer.mdc) — UI contract enforced at AI-review time.
