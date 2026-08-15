-- Personal keybindings, loaded after Omarchy defaults (see hypr/hyprland.lua).
-- Inspect live bindings with: omarchy menu keybindings --print

-- Retire the default web-app bindings; the SUPER + ALT set below replaces them
hl.unbind("SUPER + SHIFT + A")        -- ChatGPT
hl.unbind("SUPER + SHIFT + ALT + A")  -- Grok
hl.unbind("SUPER + SHIFT + C")        -- Calendar
hl.unbind("SUPER + SHIFT + E")        -- Email
hl.unbind("SUPER + SHIFT + ALT + E")  -- New email
hl.unbind("SUPER + SHIFT + Y")        -- YouTube
hl.unbind("SUPER + SHIFT + ALT + G")  -- WhatsApp
hl.unbind("SUPER + SHIFT + CTRL + G") -- Google Messages
hl.unbind("SUPER + SHIFT + P")        -- Google Photos
hl.unbind("SUPER + SHIFT + S")        -- Google Maps
hl.unbind("SUPER + SHIFT + X")        -- X
hl.unbind("SUPER + SHIFT + ALT + X")  -- X Post

-- Desktop apps
o.bind("SUPER + SHIFT + A", "AppImages", "uwsm-app -- it.mijorus.gearlever")

-- ChatGPT app takes the key from the window-grouping toggle
hl.unbind("SUPER + G")
o.bind("SUPER + G", "ChatGPT", { launch = "chatgpt", focus = "^chatgpt$" })

-- Web apps (SUPER + ALT); Gmail takes the key from the group tiling default
hl.unbind("SUPER + ALT + G")
o.bind("SUPER + ALT + A", "Claude", { webapp = "https://claude.ai" })
o.bind("SUPER + ALT + G", "Gmail", { webapp = "https://mail.google.com" })
o.bind("SUPER + ALT + H", "GitHub", { webapp = "https://github.com/" })
o.bind("SUPER + ALT + I", "LinkedIn", { webapp = "https://linkedin.com" })
o.bind("SUPER + ALT + L", "CFI", { webapp = "https://learn.corporatefinanceinstitute.com" })
o.bind("SUPER + ALT + M", "M365 Copilot", { webapp = "https://m365.cloud.microsoft/apps" })
o.bind("SUPER + ALT + P", "Proton", { webapp = "https://account.proton.me" })
o.bind("SUPER + ALT + T", "Teams", { webapp = "https://teams.live.com/v2/" })
o.bind("SUPER + ALT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + ALT + X", "X", { webapp = "https://x.com/" })
o.bind("SUPER + ALT + Y", "YouTube", { webapp = "https://youtube.com/" })
