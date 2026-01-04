{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprlock.conf".text = ''
    # General settings
    general {
      disable_loading_bar = true
      hide_cursor = true
      grace = 0
      no_fade_in = true
    }

    # Background
    background {
      monitor =
      path = screenshot
      blur_passes = 3
      blur_size = 7
      color = rgb(1e1e1e)
    }

    # Clock
    label {
      monitor =
      text = cmd[update:1000] echo "$(date +'%H:%M')"
      color = rgb(ffffff)
      font_size = 72
      font_family = monospace
      position = 0, 80
      halign = center
      valign = center
    }

    # Date
    label {
      monitor =
      text = cmd[update:1000] echo "$(date +'%Y-%m-%d')"
      color = rgb(888888)
      font_size = 20
      font_family = monospace
      position = 0, 0
      halign = center
      valign = center
    }

    # Password input field
    input-field {
      monitor =
      size = 300, 50
      outline_thickness = 1
      dots_size = 0.25
      dots_spacing = 0.3
      dots_center = true
      outer_color = rgb(458588)
      inner_color = rgb(1e1e1e)
      font_color = rgb(ffffff)
      fade_on_empty = false
      placeholder_text = <span foreground="##888888">Password...</span>
      hide_input = false
      check_color = rgb(458588)
      fail_color = rgb(ff5555)
      fail_text = <span foreground="##ff5555">Failed</span>
      position = 0, -120
      halign = center
      valign = center
    }
  '';
}
