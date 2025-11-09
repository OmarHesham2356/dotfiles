#!/usr/bin/env python3
import gi, subprocess
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk

import datetime

# Get monitor info from hyprctl
try:
    output = subprocess.check_output(["hyprctl", "monitors"]).decode()
    # Assuming first monitor is primary and Waybar is top
    primary_line = [l for l in output.splitlines() if "PRIMARY" in l][0]
    parts = primary_line.split()
    x, y = 0, 0
    for part in parts:
        if part.startswith("at:"):
            xy = part.split(":")[1].split(",")
            x, y = int(xy[0]), int(xy[1])
    # Waybar height, adjust if needed
    waybar_height = 30
except Exception:
    x, y, waybar_height = 0, 0, 30

# Create GTK window
win = Gtk.Window(title="Calendar")
win.set_type_hint(Gdk.WindowTypeHint.DOCK)
win.set_decorated(False)
win.set_resizable(False)
win.set_keep_above(True)

# Calendar widget
calendar = Gtk.Calendar()
calendar.select_day(datetime.datetime.now().day)
win.add(calendar)
win.show_all()

# Move window under top bar
win.move(x + 100, y + waybar_height)  # +100 is offset, adjust as needed

# Close when losing focus
def on_focus_out(widget, event):
    Gtk.main_quit()

win.connect("focus-out-event", on_focus_out)
Gtk.main()
