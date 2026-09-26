-- Pywal colors for Hyprland (Lua)
--
-- Hyprland >= 0.55 configures itself from `hyprland.lua`; hyprlang (the old
-- `.conf` format) is deprecated and gets removed in 0.57. `hyprland.lua`
-- pulls this file in with `loadfile()` and uses the values directly, so this
-- template must emit a plain Lua module and nothing else.
--
-- Values are bare 6-digit hex with no leading "#". `hyprland.lua` appends the
-- alpha byte itself (see its `rgba()` helper), so alpha variants are not
-- pre-computed here.
--
-- Hyprlock and Hypridle still use hyprlang, so they keep their own
-- `colors-hyprlock.conf` template which emits rgb(r,g,b) instead.

return {{
  foreground = "{foreground.strip}",
  background = "{background.strip}",
  color0  = "{color0.strip}",
  color1  = "{color1.strip}",
  color2  = "{color2.strip}",
  color3  = "{color3.strip}",
  color4  = "{color4.strip}",
  color5  = "{color5.strip}",
  color6  = "{color6.strip}",
  color7  = "{color7.strip}",
  color8  = "{color8.strip}",
  color9  = "{color9.strip}",
  color10 = "{color10.strip}",
  color11 = "{color11.strip}",
  color12 = "{color12.strip}",
  color13 = "{color13.strip}",
  color14 = "{color14.strip}",
  color15 = "{color15.strip}",
}}
