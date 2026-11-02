{
  inputs,
  lib,
  pkgs,
  ...
}:

# Plasma settings that matter on a fresh install. plasma-manager writes only
# the keys declared here, so anything else changed in System Settings sticks;
# a declared key is reset to the value below on the next home-manager switch.
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  # plasma-manager only selects the cursor theme; this installs it, and also
  # applies it to GTK and XWayland clients.
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Plasma's GTK integration rewrites ~/.gtkrc-2.0 behind home-manager's back,
  # which would otherwise block every activation.
  gtk.gtk2.force = true;

  # gui.nix points Qt at the GTK look; Plasma supplies its own platform theme.
  qt.enable = lib.mkForce false;

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "Papirus-Dark";
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
      };
      wallpaper = ../hyprland/wallpapers/nix.png;
    };

    # macOS's own dead-key scheme, so muscle memory carries between this
    # machine, the MacBook and the HHKB: right Alt is Option, and the accents
    # are mnemonic. Quotes stay literal, unlike us(intl), which matters for
    # code. Caps Lock acts as an extra Control key.
    input.keyboard = {
      layouts = [
        {
          layout = "us";
          variant = "mac";
        }
      ];
      options = [ "ctrl:nocaps" ];
    };

    # Vendor/product ids are decimal (0x093a / 0x3011).
    input.touchpads = [
      {
        name = "ASUP1208:00 093A:3011 Touchpad";
        vendorId = "2362";
        productId = "12305";
        enable = true;
        naturalScroll = true;
        tapToClick = true;
      }
    ];

    kwin = {
      nightLight = {
        enable = true;
        mode = "location";
        location = {
          latitude = "-23.55";
          longitude = "-46.63";
        };
      };
      virtualDesktops = {
        number = 4;
        rows = 1;
      };
    };

    kscreenlocker = {
      autoLock = true;
      timeout = 5; # minutes
      lockOnResume = true;
    };

    # PowerDevil takes over lid handling from logind while a Plasma session
    # runs, so the lid action is set here as well as in the host's logind
    # settings (which still apply at the login screen). Closing the lid with an
    # external monitor attached does nothing.
    powerdevil =
      let
        common = {
          whenLaptopLidClosed = "sleep";
          inhibitLidActionWhenExternalMonitorConnected = true;
          whenSleepingEnter = "standbyThenHibernate";
          turnOffDisplay.idleTimeout = 360;
          autoSuspend = {
            action = "sleep";
            idleTimeout = 1800;
          };
          dimKeyboard.enable = true;
        };
      in
      {
        AC = common;
        battery = common;
      };

    shortcuts = {
      kwin = builtins.listToAttrs (
        builtins.concatMap (n: [
          {
            name = "Switch to Desktop ${toString n}";
            value = "Meta+${toString n}";
          }
          {
            name = "Window to Desktop ${toString n}";
            value = "Meta+Shift+${toString n}";
          }
        ]) (lib.range 1 4)
      );
      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";
    };

    spectacle.shortcuts = {
      captureEntireDesktop = "Print";
      captureRectangularRegion = "Shift+Print";
      captureActiveWindow = "Meta+Print";
    };

    hotkeys.commands = {
      terminal = {
        name = "Terminal";
        key = "Meta+Return";
        command = "kitty";
      };
      files = {
        name = "Files";
        key = "Meta+E";
        command = "dolphin";
      };
      emacs = {
        name = "Emacs";
        key = "Meta+Shift+E";
        command = "emacs";
      };
      obsidian = {
        name = "Obsidian";
        key = "Meta+Shift+O";
        command = "obsidian";
      };
      spotify = {
        name = "Spotify";
        key = "Meta+Shift+M";
        command = "spotify";
      };
      discord = {
        name = "Discord";
        key = "Meta+Shift+D";
        command = "vesktop";
      };
      signal = {
        name = "Signal";
        key = "Meta+Shift+G";
        command = "signal-desktop";
      };
      onepassword = {
        name = "1Password";
        key = "Meta+Shift+/";
        command = "1password";
      };
    };
  };

  # Tailscale tray icon for connect/disconnect and status.
  systemd.user.services.tailscale-systray = {
    Unit = {
      Description = "Tailscale system tray";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service.ExecStart = "${pkgs.tailscale}/bin/tailscale systray";
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
