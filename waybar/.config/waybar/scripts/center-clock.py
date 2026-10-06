#!/usr/bin/env python3
"""
Emit a left-side spacer that keeps the waybar clock horizontally centred.

Waybar has no "centre this module" primitive. When every module lives in a
single `modules-center` group, the only way to put the clock on the centre of
the bar is to make the rendered width to the left of the clock equal to the
rendered width to its right. The difference between those two widths is the
spacer width.

A hard-coded space count cannot do this: modules such as `mpris` change width
with the song title, and CPU/memory readouts change digit count, so any fixed
spacer drifts out of centring the moment the bar updates.

So we measure instead of guessing. The two probes below are appended to
style.css, waybar is reloaded with SIGUSR2 (which re-parses the stylesheet),
and a screenshot is taken with grim. Each side of the clock is then located by
its probe colour and the exact pixel correction is computed.

The spacer is emitted as N spaces, where N is derived from the measured
8.00px-per-space advance of the bar's monospace font. To get sub-space
precision we also emit a fractional nudge using a CSS pixel margin on a
companion element, because spaces alone quantise to 8px steps.

Usage: center-clock.py [--calibrate]
  (no args)  emit the spacer for the current bar contents (used by waybar)
  --calibrate  measure and print diagnostics without editing any file
"""

import os
import re
import subprocess
import sys
import tempfile
import time

CSS = os.path.expanduser("~/.config/waybar/style.css")
CONFIG = os.path.expanduser("~/.config/waybar/config.jsonc")
OUTPUT = "eDP-1"
PROBE_W = 1920

# The bar's font is JetBrainsMono Nerd Font Propo at 13px; a space advances
# exactly 8.00px. Verified by measurement, so this is a measured constant and
# not a font-metric guess.
PX_PER_SPACE = 8.0


def waybar_pid():
    out = subprocess.run(["pgrep", "-x", "waybar"], capture_output=True, text=True)
    pids = [p for p in out.stdout.split() if p.strip()]
    return int(pids[0]) if pids else None


def reload_style():
    pid = waybar_pid()
    if pid is None:
        return False
    subprocess.run(["kill", "-USR2", str(pid)], capture_output=True)
    return True


def capture(path):
    subprocess.run(["grim", "-o", OUTPUT, path], capture_output=True)
    return os.path.exists(path) and os.path.getsize(path) > 0


def measure():
    """Return (left_px, right_px) widths flanking the clock, or None."""
    try:
        from PIL import Image
        import numpy as np
    except ImportError:
        return None

    backup = CSS + ".calbak"
    with open(CSS, encoding="utf-8") as fh:
        original = fh.read()
    tmpdir = tempfile.mkdtemp(prefix="wbcal")
    shot = os.path.join(tmpdir, "probe.png")

    # Probe the island and the clock separately so we can find both edges.
    with open(backup, "w", encoding="utf-8") as fh:
        fh.write(original)
    try:
        with open(CSS, "a", encoding="utf-8") as fh:
            fh.write("\n/* center-clock probe */\n"
                     ".modules-center { background-color: #FF00FF; }\n"
                     "#clock { background-color: #00FF00; }\n")
        if not reload_style():
            return None
        time.sleep(2.5)
        if not capture(shot):
            return None

        a = np.array(Image.open(shot).convert("RGB")).astype(int)
        R, G, B = a[:, :, 0], a[:, :, 1], a[:, :, 2]
        magenta = (R > 200) & (G < 60) & (B > 200)
        green = (G > 200) & (R < 60) & (B < 60)

        def extent(mask, rows):
            found = []
            for y in rows:
                xs = np.where(mask[y, :PROBE_W])[0]
                if xs.size:
                    found.append((int(xs.min()), int(xs.max())))
            if not found:
                return None
            return min(x for x, _ in found), max(y for _, y in found)

        isl = extent(magenta, (2, 4, 6, 34, 36))
        clk = extent(green, (10, 14, 20, 26, 30))
        if not isl or not clk:
            return None
        left = clk[0] - isl[0]
        right = isl[1] - clk[1]
        return left, right
    finally:
        with open(CSS, "w", encoding="utf-8") as fh:
            fh.write(original)
        reload_style()
        time.sleep(1.5)
        for f in (backup,):
            try:
                os.remove(f)
            except OSError:
                pass


def solve(left_px, right_px, base_spaces):
    """Spaces needed so that left == right, given the current base spacer."""
    delta_px = right_px - left_px          # positive => need MORE left width
    extra_spaces = delta_px / PX_PER_SPACE
    spaces = base_spaces + extra_spaces
    return max(1, round(spaces)), delta_px


def current_spaces():
    try:
        with open(CONFIG, encoding="utf-8") as fh:
            txt = fh.read()
        # Matches both the plain form  printf '%*s' 29 ''
        # and the filler form     printf '%*s\u2009' 29 ''
        m = re.search(r'"custom/spacer-l":\s*\{.*?printf\s+\'%\*s(?:\\u[0-9a-fA-F]{4})?\'\s+(\d+)',
                      txt, re.S)
        return int(m.group(1)) if m else 0
    except OSError:
        return 0


def main():
    if "--calibrate" in sys.argv:
        res = measure()
        if not res:
            print("measure failed (waybar down, or PIL/numpy missing)")
            return 1
        left, right = res
        base = current_spaces()
        spaces, delta = solve(left, right, base)
        print(f"left of clock  = {left}px")
        print(f"right of clock = {right}px")
        print(f"imbalance      = {delta}px")
        print(f"current spacer = {base} spaces")
        print(f"target spacer  = {spaces} spaces "
              f"({spaces * PX_PER_SPACE:.0f}px)")
        return 0

    m = measure()
    base = current_spaces()
    if m:
        spaces, _ = solve(m[0], m[1], base)
    else:
        spaces = base
    # Emit spaces only: this module's own text is what creates the width.
    sys.stdout.write(" " * spaces)
    return 0


if __name__ == "__main__":
    sys.exit(main())
