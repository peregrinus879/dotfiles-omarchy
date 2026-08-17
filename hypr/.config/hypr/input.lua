-- Personal input overrides, loaded after the Omarchy defaults.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    -- US and Arabic layouts; switch with Left Alt + Right Alt. kb_options
    -- replaces the default string, so it carries the compose and caps
    -- settings alongside the layout toggle.
    kb_layout = "us,ara",
    kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",

    touchpad = {
      -- Use natural (inverse) scrolling.
      natural_scroll = true,
    },
  },
})
