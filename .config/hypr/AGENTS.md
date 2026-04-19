# Hyprland Config — Agents Guide

## Layout

```
hyprland.conf        Main entry point — sources everything else - DO NOT EDIT
hyprland/            Upstream defaults — DO NOT EDIT
  keybinds.conf
  general.conf
  variables.conf
  rules.conf
  colors.conf
  execs.conf
  env.conf
custom/              User overrides — edit here
  keybinds.conf
  general.conf
  rules.conf
  execs.conf
  env.conf
hyprlock.conf        Lock screen
hypridle.conf        Idle daemon
monitors.conf        Monitor layout (nwg-displays) - AUTO-GENERATED, DO NOT EDIT
workspaces.conf      Workspace layout - AUTO-GENERATED, DO NOT EDIT
```

## Loading order

1. `hyprland/env.conf` → `custom/env.conf`
2. `hyprland/variables.conf` → `custom/variables.conf`
3. Default sections (conditionally via `$dontLoad*` flags): execs, general, rules, colors, keybinds
4. Custom overrides: execs, general, rules, keybinds
5. `workspaces.conf`, `monitors.conf`, `hyprland/shellOverrides/main.conf`

Custom files are sourced **after** defaults, so they can `unbind`/override anything from the defaults.

## Keybinds

The user has a **Corne v4 split keyboard** with no dedicated Super key. Consult `corne_v4.layout.json` in the repo root before proposing any keybind changes.

- **Hyper key** = tap → Escape, hold → `Ctrl+Shift+Alt+Super` (all four modifiers). Left thumb key.
- **Layer 4** (numbers, F-keys) = also a left thumb key. `Hyper+number` and `Hyper+Fkey` are physically impossible.
- **Layer 1** (navigation/macros) = right thumb key. Right-side macros send `Ctrl+Shift+Super+N`; holding the Layer 1 Alt key too gives `Ctrl+Shift+Alt+Super+N` = Hyper+N.
- **Fallback modifier**: `Ctrl+Shift` — not `Ctrl+Alt` (Alt is not easily accessible).

In config, write Hyper as: `Ctrl+Shift+Alt+Super`

Do **not** suggest `Hyper+number`, `Hyper+Fkey`, or `Ctrl+Alt+*` keybinds.
