-- Personal look'n'feel overrides, loaded after the Omarchy defaults and after
-- the active theme's Hyprland fragment, so these values hold under any theme.
-- The Quickshell shell mirrors decoration:rounding into its menu, bar-item,
-- OSD, and notification radii; rounding_power shapes windows only, and the
-- window-no-gaps toggle forces rounding 0 while active.

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
  },

  decoration = {
    rounding = 6,
    rounding_power = 3,
  },
})
