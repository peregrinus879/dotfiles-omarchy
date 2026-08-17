-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1.6

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- GU605C laptop panel.
hl.monitor({ output = "eDP-1", mode = "2560x1600@240", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- omarchy 4.0.0's o.shell_succeeds() cannot read child exit statuses inside
-- Hyprland (basecamp/omarchy#6914), so default/hypr/nvidia.lua never sets the
-- NVIDIA client env on this GSP-class GPU. Remove when the packaged omarchy
-- ships the upstream fix (0965ac2e4f, first release after v4.0.0).
hl.env("NVD_BACKEND", "direct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
