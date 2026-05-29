/**
 * Mantle-aligned plugin UI — see docs/design/plugin-ui-system.md (kindling repo).
 */
import {
  Button,
  MantleProvider,
  Page,
  PageHeader,
  useChromeSlot,
  useTheme,
} from "@kindling/mantle";
import { useEffect } from "react";

export function App() {
  return (
    <MantleProvider>
      <PluginContent />
    </MantleProvider>
  );
}

function PluginContent() {
  const { mode } = useTheme();
  const { mount } = useChromeSlot("top", "app");

  useEffect(() => {
    mount({
      kind: "button",
      id: "demo-add",
      label: "Add",
      icon: "plus",
      variant: "accent",
    });
  }, [mount]);

  return (
    <Page>
      <PageHeader title="{{ plugin_name }}" />
      <p>Theme: {mode ?? "standalone"}</p>
      <Button variant="accent">Example action</Button>
    </Page>
  );
}
