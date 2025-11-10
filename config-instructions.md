# ⚙️ Configuration Instructions

This document explains how the Hyprland config in this setup is structured, which files to edit, and how to safely customize them.

---

## 🧩 Folder Structure

```
~/.config/hypr/
│
├── hyprland.conf               # Main config file (loads all sub-configs)
│
├── conf/
│   ├── autostart.conf          # Apps and scripts that launch automatically
│   ├── keyboard.conf           # Keyboard layout, bindings, and input options
│   ├── keybinding.conf         # All Hyprland keybinds
│   ├── decoration.conf         # Borders, rounding, shadows, and visuals
│   ├── layout.conf             # Gaps, tiling layout, and workspace settings
│   ├── window.conf             # Window rules and behaviors
│   ├── windowrule.conf         # App-specific rules (e.g., floating, opacity)
│   ├── animation.conf          # Animations and transitions
│   ├── monitors/default.conf   # Monitor layout and scaling
│   ├── environment.conf        # Environment variables
│   ├── cursor.conf             # Cursor theme and size
│   ├── misc.conf               # Miscellaneous settings
│   ├── custom.conf             # Your own custom tweaks (edit freely here)
│
├── colors.conf                 # Main color variables
└── themes/                     # Optional themes for Waybar / Wallpapers
```

Perfect 😎 — that’s a great structure dump.
Here’s how you can turn that into a clean **Markdown file** (`waybar-structure.md`) that clearly shows how your Waybar configuration is organized:

---

### 🧱 `waybar-structure.md`

```markdown
# Waybar Configuration Structure

This folder contains all Waybar configuration files, themes, modules, and scripts used in the setup.

```

.
├── **colors.css** — global color definitions
├── **modules.json** — defines Waybar modules
├── **launch.sh** — script to start Waybar
├── **toggle.sh** — toggles Waybar visibility
├── **themeswitcher.sh** — switches between light/dark themes
└── **themes/**
├── **assets/** — icons and images (AI, Hyprland, ML4W, OpenAI)
├── **default/** — default Waybar configuration and style
│   ├── config
│   ├── config.sh
│   └── style.css
├── **ml4w/** — ML4W (My Linux For Work) base themes
│   ├── black/style.css
│   ├── default/style.css
│   ├── white/style.css
│   └── config
├── **ml4w-minimal/** — minimalistic ML4W variant
│   ├── config
│   ├── config.sh
│   ├── style.css
│   └── README.md
├── **ml4w-modern/** — modern ML4W variant (most used)
│   ├── config
│   ├── style.css
│   ├── black/style.css
│   ├── colored/style.css
│   ├── default/style.css
│   ├── minimal/style.css
│   └── white/style.css
└── **starter/** — base template for beginners
├── config
├── config.sh
├── modules.json
├── style.css
└── README.md

```

---

### 💡 Usage Notes
- The **active Waybar configuration** is usually linked or referenced from:
```

~/.config/waybar/themes/ml4w-modern/config

```
- You can switch themes or edit styles from:
```

~/.config/waybar/themes/ml4w-modern/style.css

````

---

## 🧠 How the Config Works

* The main file `hyprland.conf` **sources** (loads) everything under `conf/` in a modular way.
* This means you **don’t edit `hyprland.conf` directly**, unless you’re adding a new source file.
* You can safely edit any `.conf` file under `conf/` to customize your setup.

---

## 🛠 Workflow for Editing

1. **Find the right file**

   * For visuals → edit `decoration.conf`
   * For gaps or tiling → edit `layout.conf`
   * For keybinds → edit `keybinding.conf`
   * For startup apps → edit `autostart.conf`
   * For your personal tweaks → edit `custom.conf`

2. **Make changes**
   Use a terminal editor (like `micro`, `nvim`, or `nano`) or a GUI editor.

3. **Reload Hyprland**

   ```bash
   hyprctl reload
   ```

   This applies the changes instantly without restarting your session.

4. **Test and iterate**

   * Try different values for gaps, shadows, or animations.
   * If something breaks, comment out the new lines and reload again.

---
