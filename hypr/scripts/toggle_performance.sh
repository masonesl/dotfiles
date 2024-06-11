#!/usr/bin/env sh

# Maintain a file that, if exists, means "performance" mode is on.
WM_PERFORMANCE_MODE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wm_performance_mode"

if [ -e "$WM_PERFORMANCE_MODE" ] ; then
  hyprctl keyword decoration:blur:enabled     true
  hyprctl keyword decoration:drop_shadow      true
  hyprctl keyword decoration:active_opacity   0.95
  hyprctl keyword decoration:inactive_opacity 0.95
  hyprctl keyword animations:enabled           true
  rm "$WM_PERFORMANCE_MODE"
else
  hyprctl keyword decoration:blur:enabled     false
  hyprctl keyword decoration:drop_shadow      false
  hyprctl keyword decoration:active_opacity   1
  hyprctl keyword decoration:inactive_opacity 1
  hyprctl keyword animations:enabled           false
  touch "$WM_PERFORMANCE_MODE"
fi
