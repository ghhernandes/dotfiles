{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.kitty # Terminal emulator
    pkgs.rofi # Application launcher
    pkgs.rofimoji # Emoji/symbol picker (Super+.), uses rofi as its selector
    pkgs.waybar # Status bar
    pkgs.dunst # Notification daemon
    pkgs.libnotify # Notification utilities (notify-send)
    pkgs.pamixer # Audio control
    pkgs.playerctl # Media player control
    pkgs.pavucontrol # GUI audio control
    pkgs.blueman # Bluetooth manager GUI
    pkgs.hyprlock # Screen locker
    pkgs.impala
    pkgs.bluetui
    pkgs.btop # System monitor (waybar cpu/memory click target)
    pkgs.brightnessctl # Backlight control (laptops; no-op without a backlight device)
    pkgs.hyprpolkitagent # GUI polkit auth prompts (mounting drives, admin actions)
    pkgs.cliphist # Clipboard history (rofi picker on mod+shift+v)
    pkgs.udiskie # Auto-mount removable drives
    pkgs.wlsunset # Night light / blue-light schedule
  ];

  # Cursor theme for Wayland/Hyprland (hyprcursor), X11 apps, and GTK.
  # Without this, Hyprland falls back to its built-in default cursor.
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # Start the session through UWSM, which runs the compositor as a systemd user
  # unit and so activates graphical-session.target. Launching Hyprland bare
  # leaves that target inactive, and every user service bound to it (hypridle,
  # waybar, dunst, ...) silently never starts.
  #
  # Restricted to tty1 so the other VTs stay plain shells: if the session fails
  # to come up, tty2-6 are still a way in. Deliberately not `exec` for the same
  # reason — a failed start drops back to this shell instead of logging out.
  #
  # start-hyprland rather than the Hyprland binary: it is what raises the
  # compositor's scheduling priority, and Hyprland warns loudly when bypassed.
  # This mirrors the stock hyprland.desktop, which UWSM is designed to launch.
  #
  # Given as an absolute store path because the system tree and this profile
  # ship different Hyprland versions (system nixpkgs is stable, home-manager
  # follows unstable), and the config here is written against the profile's.
  # Note also that hyprland-uwsm.desktop is *itself* `uwsm start ...`, meant
  # for a display manager — passing it to `uwsm start` would nest UWSM in UWSM.
  programs.zsh.loginExtra = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      uwsm start -e -D Hyprland ${config.wayland.windowManager.hyprland.finalPackage}/bin/start-hyprland
    fi
  '';

  # Session services. These are all bound to graphical-session.target, so
  # systemd starts them with the session, restarts them on failure, and logs
  # them to `journalctl --user -u <name>` — none of which applies to the
  # exec-once entries they replace.
  services = {
    # On-screen display for volume/brightness/caps-lock changes.
    swayosd.enable = true;

    hyprpolkitagent.enable = true; # GUI polkit auth prompts

    cliphist = {
      enable = true;
      allowImages = true;
    };

    udiskie = {
      enable = true;
      automount = true;
      tray = "auto"; # only show the icon while a removable device is mounted
    };

    # Night light, São Paulo (drives sunrise/sunset from lat/long).
    wlsunset = {
      enable = true;
      latitude = -23.55;
      longitude = -46.63;
    };

    hyprpaper = {
      enable = true;
      settings = {
        preload = [
          "${config.home.homeDirectory}/.dotfiles/nix/home/hyprland/wallpapers/nix.png"
        ];
        wallpaper = [
          ",${config.home.homeDirectory}/.dotfiles/nix/home/hyprland/wallpapers/nix.png"
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Disable to avoid conflicts with UWSM
    # This module's settings are written in hyprlang. Pin it so bumping
    # home.stateVersion to 26.05 (which flips the default to lua) can't
    # silently break the config.
    configType = "hyprlang";

    settings = {
      # Generic catch-all; hosts with specific output requirements (fixed
      # desktop monitor, laptop panel + dock, ...) override this with mkForce.
      monitor = [ ",preferred,auto,1" ];

      "$mod" = "SUPER";

      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";

      # Force Electron/Chromium apps (Chrome, Spotify, VS Code, ...) onto native
      # Wayland so they render crisply at fractional scale instead of blurry
      # XWayland. The nixpkgs wrappers add the right flags when this is set.
      env = [
        "NIXOS_OZONE_WL,1"
      ];

      # Window rules for fixed workspaces
      windowrule = [
        # 1Password: Floating and centered
        "float on, match:class ^(1password)$"
        "center on, match:class ^(1password)$"
        "size 800 600, match:class ^(1password)$"

        # Volume control: Floating and centered
        "float on, match:class ^(org.pulseaudio.pavucontrol)$"
        "center on, match:class ^(org.pulseaudio.pavucontrol)$"
        "size 800 600, match:class ^(org.pulseaudio.pavucontrol)$"

        # Bluetui: Floating and centered
        "float on, match:class ^(bluetui-float)$"
        "center on, match:class ^(bluetui-float)$"
        "size 800 600, match:class ^(bluetui-float)$"

        # Impala: Floating and centered
        "float on, match:class ^(impala-float)$"
        "center on, match:class ^(impala-float)$"
        "size 800 600, match:class ^(impala-float)$"

        # btop: Floating and centered
        "float on, match:class ^(btop-float)$"
        "center on, match:class ^(btop-float)$"
        "size 1000 700, match:class ^(btop-float)$"

        # Gaming: Auto fullscreen
        "fullscreen on, match:class ^(steam_app_).*"
        "fullscreen on, match:class ^(Wine)$"
        "fullscreen on, match:class ^(steam_proton)$"
        "fullscreen on, match:title ^(.* - Wine desktop)$"
      ];

      bind = [
        # Applications
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"

        "$mod, SPACE, exec, $menu"
        "$mod SHIFT, E, exec, emacs"
        "$mod SHIFT, O, exec, obsidian"
        "$mod SHIFT, M, exec, spotify"
        "$mod SHIFT, D, exec, vesktop"
        "$mod SHIFT, G, exec, signal-desktop"
        "$mod SHIFT, slash, exec, 1password"

        "$mod, backslash, exec, hyprlock"
        "$mod, M, exec, rofi-power"
        "$mod, B, exec, kitty --class bluetui-float bluetui"
        "$mod, N, exec, focus-mode toggle"
        "$mod, C, exec, caffeine toggle"
        "$mod SHIFT, C, exec, caffeine menu"
        "$mod, period, exec, rofimoji --selector rofi --action copy"
        "$mod SHIFT, V, exec, cliphist list | rofi -dmenu -theme custom | cliphist decode | wl-copy"

        # Screenshots
        ", Print, exec, screenshot full"
        "SHIFT, Print, exec, screenshot region"
        "CTRL, Print, exec, screenshot clipboard"
        "$mod, Print, exec, screenshot window"

        # Move focus with mod + hjkl or arrow keys
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Swap windows with mod + shift + hjkl
        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, L, swapwindow, r"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, J, swapwindow, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      # Resize windows with mod + CTRL + hjkl
      binde = [
        "$mod CTRL, H, resizeactive, -50 0"
        "$mod CTRL, L, resizeactive, 50 0"
        "$mod CTRL, K, resizeactive, 0 -50"
        "$mod CTRL, J, resizeactive, 0 50"
      ];

      # Media and audio control keybindings
      bindl = [
        # Lock on lid close. logind still decides whether to sleep (and honours
        # caffeine's inhibitor via LidSwitchIgnoreInhibited=no), but it can only
        # take one action per lid event, so the lock has to come from here to
        # also cover the case where sleeping is inhibited.
        ", switch:on:Lid Switch, exec, pidof hyprlock || hyprlock"

        # Audio controls (swayosd shows an on-screen indicator)
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # Screen backlight (laptops; no-op without a backlight device)
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

        # Keyboard backlight (asus::kbd_backlight, levels 0-3; no-op elsewhere)
        ", XF86KbdBrightnessUp, exec, brightnessctl -d asus::kbd_backlight set +1"
        ", XF86KbdBrightnessDown, exec, brightnessctl -d asus::kbd_backlight set 1-"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "ctrl:nocaps"; # Caps Lock acts as an extra Control key
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      # 3-finger horizontal touchpad swipe to switch workspaces.
      # Hyprland 0.49+ replaced the old `gestures { workspace_swipe }` section
      # with this keyword. No-op on machines without a touchpad.
      gesture = [
        "3, horizontal, workspace"
      ];

      # Look & feel adapted from Omarchy (basecamp/omarchy default/hypr/looknfeel.conf).
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # Gradient active border (cyan -> green, 45deg), Hyprland's signature palette.
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true; # drag window edges to resize (deviates from Omarchy's false)
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          special = true;
          brightness = 0.60;
          contrast = 0.75;
        };
        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 3.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
          "specialWorkspace, 1, 3, easeOutQuint, slidevert"
        ];
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_scale_notification = true;
        focus_on_activate = true;
        on_focus_under_fullscreen = 1;
        anr_missed_pings = 3;
        # Wake the screen on input (moved here from the input section).
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };

      cursor = {
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };

      binds = {
        hide_special_on_workspace_change = true;
      };
    };
  };
}
