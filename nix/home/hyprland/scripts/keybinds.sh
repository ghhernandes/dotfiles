#!/usr/bin/env bash
# Prints all active Hyprland keybindings in a readable format

hyprctl binds -j | jq -r '
  .[] |
  (
    (if .modmask == 64 then "SUPER"
     elif .modmask == 65 then "SUPER + SHIFT"
     elif .modmask == 68 then "SUPER + CTRL"
     elif .modmask == 1 then "SHIFT"
     elif .modmask == 4 then "CTRL"
     elif .modmask == 0 then ""
     else "mod:\(.modmask)"
     end) as $mod |
    (if $mod == "" then .key else "\($mod) + \(.key)" end) as $combo |
    "\($combo)|\(.dispatcher)|\(.arg)"
  )
' | column -t -s '|' -N "KEYS,ACTION,ARGUMENT"
