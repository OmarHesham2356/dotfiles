#!/usr/bin/env python3
import json
import subprocess
import sys

def get_workspaces():
    try:
        result = subprocess.run(["hyprctl", "workspaces", "-j"], 
                              capture_output=True, text=True, timeout=2)
        return json.loads(result.stdout) if result.stdout else []
    except:
        return []

def get_clients():
    try:
        result = subprocess.run(["hyprctl", "clients", "-j"], 
                              capture_output=True, text=True, timeout=2)
        return json.loads(result.stdout) if result.stdout else []
    except:
        return []

def main():
    workspaces = get_workspaces()
    clients = get_clients()
    
    # Map window addresses to app classes
    window_map = {c["address"]: c["class"] for c in clients}
    
    # Sort workspaces by ID
    sorted_workspaces = sorted(workspaces, key=lambda x: x.get("id", 0))
    
    # Build the output string with icons separated by spaces
    icons = []
    for ws in sorted_workspaces:
        ws_id = ws.get("id", 0)
        windows = ws.get("windows", 0)
        
        if windows == 0:
            # Empty workspace - use number fallback
            icon = f" {ws_id} "
        else:
            # Get the last focused window in this workspace
            last_window = ws.get("lastwindow", "")
            app_class = window_map.get(last_window, "").lower()
            
            # Map app classes to Nerd Font icons
            icon_map = {
                # Browsers
                "firefox": "󰈹",
                "firefoxdeveloperedition": "󰈹",
                "chromium": "󰊯",
                "google-chrome": "󰊯",
                "brave": "󰊯",
                "brave-browser": "󰊯",
                "zen": "󰊯",
                "zen-browser": "󰊯",
                "zen_alpha": "󰊯",
                "librewolf": "󰈹",
                "waterfox": "󰈹",
                "opera": "󰉫",
                "vivaldi": "󰊯",
                "edge": "󰇩",
                "microsoft-edge": "󰇩",
                
                # Terminals
                "kitty": "󰄛",
                "alacritty": "󰄛",
                "foot": "󰄛",
                "wezterm": "󰄛",
                "gnome-terminal": "󰄛",
                "konsole": "󰄛",
                "xfce4-terminal": "󰄛",
                "terminator": "󰄛",
                "tilix": "󰄛",
                "warp": "󰄛",
                "rio": "󰄛",
                
                # File Managers
                "thunar": "󰉋",
                "nautilus": "󰉋",
                "dolphin": "󰉋",
                "pcmanfm": "󰉋",
                "nemo": "󰉋",
                "caja": "󰉋",
                "ranger": "󰉋",
                "lf": "󰉋",
                "nnn": "󰉋",
                
                # Chat/Social
                "discord": "󰙯",
                "discordcanary": "󰙯",
                "discordptb": "󰙯",
                "slack": "󰒱",
                "telegramdesktop": "󰔁",
                "telegram": "󰔁",
                "signal": "󰭹",
                "whatsdesk": "󰖣",
                "whatsapp": "󰖣",
                "caprine": "󰈰",
                "teams": "󰊻",
                "microsoft teams": "󰊻",
                
                # Media
                "spotify": "󰓇",
                "vlc": "󰕼",
                "mpv": "󰕼",
                "obs": "󰑋",
                "obs-studio": "󰑋",
                "kdenlive": "󰕧",
                "gimp": "󰨈",
                "krita": "󰨈",
                "inkscape": "󰨈",
                "blender": "󰂫",
                "audacity": "󰎆",
                "rhythmbox": "󰓇",
                "clementine": "󰓇",
                "deadbeef": "󰓇",
                
                # Gaming
                "steam": "󰓓",
                "steAM": "󰓓",
                "lutris": "󰓓",
                "heroic": "󰓓",
                "heroicgameslauncher": "󰓓",
                "minecraft": "󰍳",
                "prismlauncher": "󰍳",
                "multimc": "󰍳",
                "atlauncher": "󰍳",
                "gdlauncher": "󰍳",
                "bottles": "󰜪",
                "bottles-cli": "󰜪",
                
                # Development
                "code": "󰨞",
                "code-oss": "󰨞",
                "vscodium": "󰨞",
                "jetbrains-studio": "󰘦",
                "jetbrains-idea": "󰘦",
                "jetbrains-pycharm": "󰘦",
                "jetbrains-webstorm": "󰘦",
                "jetbrains-clion": "󰘦",
                "sublime_text": "󰘦",
                "subl": "󰘦",
                "atom": "󰘦",
                "neovide": "󰘦",
                "nvim": "󰘦",
                "vim": "󰘦",
                "emacs": "󰘦",
                "zeditor": "󰘦",
                "zed": "󰘦",
                "postman": "󰘦",
                "insomnia": "󰘦",
                "beekeeper-studio": "󰘦",
                "tableplus": "󰘦",
                "github-desktop": "󰊤",
                "gitkraken": "󰊤",
                
                # Productivity
                "obsidian": "󰠮",
                "notion": "󰎚",
                "notion-calendar": "󰃭",
                "thunderbird": "󰇮",
                "evolution": "󰇮",
                "geary": "󰇮",
                "mailspring": "󰇮",
                "libreoffice": "󰏆",
                "libreoffice-writer": "󰈭",
                "libreoffice-calc": "󰈹",
                "libreoffice-impress": "󰈩",
                "soffice": "󰏆",
                "onlyoffice": "󰏆",
                "wps": "󰏆",
                "wpsoffice": "󰏆",
                "figma": "󰏆",
                "figma-linux": "󰏆",
                
                # System/Utilities
                "pavucontrol": "󰕾",
                "blueman-manager": "󰂯",
                "nm-connection-editor": "󰖩",
                "gnome-disks": "󰋊",
                "gparted": "󰋊",
                "timeshift": "󰃰",
                "baobab": "󰃰",
                "htop": "󰄉",
                "btop": "󰄉",
                "nvtop": "󰄉",
                
                # Other
                "qbittorrent": "󰄛",
                "transmission": "󰄛",
                "deluge": "󰄛",
            }
            
            # Get icon or fallback to workspace number
            icon = icon_map.get(app_class)
            if icon:
                icon = f" {icon} "
            else:
                # Fallback to workspace number if no icon found
                icon = f" {ws_id} "
        
        icons.append(icon)
    
    # Output plain text separated by spaces
    output = " ".join(icons)
    print(output)
    sys.stdout.flush()

if __name__ == "__main__":
    main()
