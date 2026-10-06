-- Hyprland configuration
--
-- Hyprland >= 0.55 configures itself from Lua; the old hyprlang `.conf` format
-- is deprecated and hyprlang is removed from hyprland.conf in 0.57. The other
-- hypr* tools (hyprlock, hypridle) still use hyprlang, so hyprlock.conf and
-- hypridle.conf in this directory stay hyprlang and are not affected.
--
-- Validate with:  Hyprland --verify-config
--
-- API reference: https://wiki.hypr.land/configuring/

-----------------------
---- PALETTE (pywal) --
-----------------------

-- pywal writes ~/.cache/wal/colors-hyprland.lua (see
-- dotfiles/wal/.config/wal/templates/) whenever the theme changes. loadfile()
-- is used rather than require() on purpose: require() memoises in
-- package.loaded, which would keep serving stale colours across a reload.
local WAL_DIR = (os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")) .. "/wal"

local function loadPalette()
	local chunk, err = loadfile(WAL_DIR .. "/colors-hyprland.lua")
	if not chunk then
		print("[hyprland] no pywal palette (" .. tostring(err) .. "), using fallback")
		return nil
	end

	local ok, palette = pcall(chunk)
	if not ok or type(palette) ~= "table" then
		print("[hyprland] pywal palette unreadable: " .. tostring(palette))
		return nil
	end

	return palette
end

-- catppuccin-mocha, so a fresh login still looks right before pywal has run.
local pal = loadPalette()
	or {
		foreground = "cdd6f4",
		background = "1e1e2e",
		color0 = "45475a",
		color1 = "f38ba8",
		color2 = "a6e3a1",
		color3 = "f9e2af",
		color4 = "89b4fa",
		color5 = "f5c2e7",
		color6 = "94e2d5",
		color7 = "bac2de",
		color8 = "585b70",
		color9 = "f38ba8",
		color10 = "a6e3a1",
		color11 = "f9e2af",
		color12 = "89b4fa",
		color13 = "f5c2e7",
		color14 = "94e2d5",
		color15 = "a6adc8",
	}

-- pal.* is bare 6-digit hex, so the alpha byte is appended here. This is what
-- the old `$color5cc` / `$color800` / `$color077` hyprlang variables did.
local function rgba(key, alpha)
	return "rgba(" .. pal[key] .. (alpha or "ff") .. ")"
end

-----------------------
---- ENVIRONMENT ------
-----------------------

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("GTK_BACKEND", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
-- Intel VA-API on Wayland (iHD driver)
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("LIBVA_DRIVERS_PATH", "/usr/lib/dri")

-- ~/.local/bin holds the helper scripts bound below (audio-switcher,
-- record-screen, scratchpad, ...). A GUI login session gets its PATH from PAM,
-- not from ~/.zshrc, so make it explicit here for the compositor and everything
-- it spawns.
local HOME = os.getenv("HOME")
hl.env(
	"PATH",
	HOME
		.. "/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_pem:/usr/bin/core_perl"
)
hl.env("SSH_AUTH_SOCK", HOME .. "/.gnupg/S.gpg-agent.ssh")
hl.env("GPG_AGENT_INFO", HOME .. "/.gnupg/S.gpg-agent:0:1")

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-1", mode = "1920x1080@120", position = "-1920x0", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1080@120", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

for ws = 1, 5 do
	hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-1" })
end

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })

for ws = 6, 10 do
	hl.workspace_rule({ workspace = tostring(ws), monitor = "eDP-1" })
end

---------------------------
---- LOOK AND FEEL -------
---------------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = {
				colors = { rgba("color5", "cc"), rgba("color4", "cc"), rgba("color2", "cc") },
				angle = 45,
			},
			inactive_border = rgba("color8", "00"),
		},
		layout = "dwindle",
		hover_icon_on_border = true,
	},

	decoration = {
		rounding = 14,
		rounding_power = 2.2,
		active_opacity = 0.92,
		inactive_opacity = 0.8,
		fullscreen_opacity = 1.0,

		blur = {
			enabled = true,
			size = 16,
			passes = 4,
			ignore_opacity = false,
			xray = true,
			noise = 0.02,
			contrast = 0.85,
			brightness = 1.0,
			vibrancy = 0.5,
			vibrancy_darkness = 0.0,
		},

		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			scale = 0.98,
			color = rgba("color0", "77"),
			offset = "0 4",
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

local ANIMATIONS = {
	{ leaf = "windows", bezier = "wind" },
	{ leaf = "windowsIn", bezier = "winIn" },
	{ leaf = "windowsOut", bezier = "winOut" },
	{ leaf = "windowsMove", bezier = "wind" },
	{ leaf = "workspaces", bezier = "wind" },
	{ leaf = "fade", bezier = "liner" },
	{ leaf = "fadeDim", bezier = "liner" },
	{ leaf = "border", bezier = "liner" },
	{ leaf = "borderangle", bezier = "liner" },
}

for _, anim in ipairs(ANIMATIONS) do
	hl.animation({ leaf = anim.leaf, enabled = true, speed = 6, bezier = anim.bezier })
end

-----------------------
---- LAYOUTS -----------
-----------------------

hl.config({
	dwindle = {
		preserve_split = true,
		force_split = 2,
		special_scale_factor = 0.8,
		split_width_multiplier = 1.0,
		smart_split = false,
		smart_resizing = false,
		permanent_direction_override = true,
	},

	master = {
		special_scale_factor = 0.8,
		mfact = 0.55,
		orientation = "center",
		new_on_top = true,
		allow_small_split = true,
		drop_at_cursor = false,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us,ara",
		kb_options = "grp:alt_shift_toggle",
		follow_mouse = 1,
		sensitivity = 0,
		numlock_by_default = true,
		force_no_accel = false,
		float_switch_override_focus = 2,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 1.0,
		},
	},
})

----------------
---- MISC ----
----------------

hl.config({
	misc = {
		disable_autoreload = false,
		focus_on_activate = true,
		always_follow_on_dnd = true,
		animate_mouse_windowdragging = false,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = false,
		disable_hyprland_logo = true,
		vrr = 0,
	},

	binds = {
		allow_workspace_cycles = true,
		ignore_group_lock = false,
		workspace_back_and_forth = true,
		movefocus_cycles_fullscreen = false,
		scroll_event_delay = 300,
	},

	debug = {
		disable_logs = true,
		disable_time = false,
	},
})

-----------------------
---- KEYBINDINGS ------
-----------------------

local SUPER = "SUPER"

-- Core
hl.bind(SUPER .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(SUPER .. " + C", hl.dsp.window.close())
hl.bind(SUPER .. " + M", hl.dsp.exit())
hl.bind(SUPER .. " + E", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind(SUPER .. " + F", hl.dsp.window.fullscreen())
hl.bind(SUPER .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(SUPER .. " + P", hl.dsp.window.pseudo())
hl.bind(SUPER .. " + J", hl.dsp.layout("togglesplit"))

-- Apps
hl.bind(SUPER .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(SUPER .. " + SHIFT + R", hl.dsp.exec_cmd("pill-launcher"))
hl.bind(SUPER .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(SUPER .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))
hl.bind(SUPER .. " + SHIFT + A", hl.dsp.exec_cmd("audio-switcher"))
hl.bind(SUPER .. " + A", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(SUPER .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(SUPER .. " + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(SUPER .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(SUPER .. " + B", hl.dsp.exec_cmd("killall waybar; sleep 0.5; waybar &"))
hl.bind(SUPER .. " + grave", hl.dsp.exec_cmd("scratchpad"))
hl.bind(SUPER .. " + Print", hl.dsp.exec_cmd("record-screen"))
hl.bind(SUPER .. " + SHIFT + W", hl.dsp.exec_cmd("web-search"))
hl.bind(SUPER .. " + SHIFT + N", hl.dsp.exec_cmd("kitty --class=nmtui -e nmtui"))
hl.bind(SUPER .. " + SHIFT + O", hl.dsp.exec_cmd("quick-notes"))
hl.bind(SUPER .. " + period", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))
hl.bind(SUPER .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(SUPER .. " + T", hl.dsp.exec_cmd("hover-term toggle"))
hl.bind(SUPER .. " + SHIFT + T", hl.dsp.exec_cmd("hover-term open"))
hl.bind(SUPER .. " + SHIFT + I", hl.dsp.exec_cmd("project-launcher"))
hl.bind(SUPER .. " + SHIFT + U", hl.dsp.exec_cmd("notes-launcher"))

-- Group
hl.bind(SUPER .. " + SHIFT + V", hl.dsp.window.move({ into_group = "left" }))
hl.bind(SUPER .. " + N", hl.dsp.group.toggle())
hl.bind(SUPER .. " + SHIFT + C", hl.dsp.window.move({ out_of_group = true }))

-- Focus
hl.bind(SUPER .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(SUPER .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(SUPER .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(SUPER .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap
hl.bind(SUPER .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(SUPER .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(SUPER .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(SUPER .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))

-- Workspaces, and move-to-workspace
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(SUPER .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(SUPER .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse
hl.bind(SUPER .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(SUPER .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys. `repeating` is the old bindel, `locked` the old bindl.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"), { locked = true })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"), { locked = true })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m window"), { locked = true })

------------------------------
---- WINDOW RULES -----------
------------------------------

local function floatOn(match)
	hl.window_rule({ match = match, float = true })
end

-- Global rounding is 14, but a fullscreen window must stay square: rounded
-- corners there expose the wallpaper and read as the window floating.
hl.window_rule({ match = { fullscreen = true }, rounding = 0 })

hl.window_rule({ match = { class = "^(vesktop)$" }, workspace = "5" })
hl.window_rule({ match = { class = "^(obsidian)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(scratchpad)$" }, workspace = "special:scratchpad", float = true })

hl.window_rule({ match = { title = "^(.* — Mozilla Firefox)$" }, workspace = "2" })
hl.window_rule({ match = { title = "^(zen-beta — Zen Browser)$" }, workspace = "2" })

-- Picture-in-picture is pinned so it stays put when focus moves.
hl.window_rule({ match = { title = "^(picture in picture)$" }, float = true, pin = true })

floatOn({ class = "^(copyq)$" })
floatOn({ class = "^(pavucontrol)$" })
floatOn({ class = "^(blueman-manager)$" })
floatOn({ class = "^(org.gnome.Calculator)$" })
floatOn({ class = "^(org.gnome.Nautilus)$" })
floatOn({ class = "^(thunar)$" })
floatOn({ class = "^(imv)$" })
floatOn({ class = "^(mpv)$" })
floatOn({ class = "^(notes)$" })
floatOn({ class = "^(nmtui)$" })

-------------------------
---- LAYER RULES --------
-------------------------

-- waybar is the "dynamic island": a single pill floating below the top edge.
-- Its rounded shape and drop shadow come from GTK CSS (border-radius +
-- box-shadow on window#waybar). hl.layer_rule in 0.56.2 accepts only
-- no_anim / blur / ignore_alpha / order / dim_around, so the pill cannot be
-- rounded compositor-side the way windows are.
--
-- blur is deliberately OFF here. Hyprland blurs the entire layer-surface
-- RECTANGLE and ignores the alpha-rounded shape GTK paints, so an enabled blur
-- bleeds past the pill's rounded corners and makes them look square again.
-- Measured in the corner notches: texture fell to ~48% of the surrounding
-- wallpaper (blurred) while the pill interior flattened to 0.28x. The frosted
-- look is produced in style.css with stacked translucent layers instead, which
-- keeps the corners crisp. Waybar has its own on/off bind (SUPER+B).
hl.layer_rule({ match = { namespace = "^(waybar)$" }, no_anim = true, blur = false })

hl.layer_rule({ match = { namespace = "^(swaync-control-center)$" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "^(swaync-notification-window)$" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "^(rofi)$" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "^(copyq)$" }, order = 9999 })

------------------
---- AUTOSTART ----
------------------

-- hyprland.start fires once per session and not on reload, which is exactly
-- what the old exec-once gave us.
hl.on("hyprland.start", function()
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("waybar &")
	hl.exec_cmd("swaync")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh,gpg")
	hl.exec_cmd("blueman-applet")
end)
