{
  config,
  lib,
  pkgs,
  ...
}:

# The desktop's "feature" record: one declaration owns a script, the keybinds
# that invoke it, and the waybar widget that displays it. Hyprland binds,
# waybar modules, and waybar CSS are derived from it rather than hand-written,
# so a rename can't leave a dangling string behind in some other file.
#
# `mkBefore`/`mkAfter` on the renderer outputs let this module coexist with
# still-hand-written config in hyprland.nix/waybar.nix during migration: both
# styles append into the same merged list/string rather than one replacing
# the other.
let
  cfg = config.desktop;
  inherit (lib) mkOption types;

  bindType = types.submodule {
    options = {
      key = mkOption { type = types.str; };
      mods = mkOption {
        type = types.str;
        default = "$mod";
      };
      run = mkOption {
        type = types.str;
        default = "";
      }; # "" = bare invocation, no subcommand
      # binde repeats while held, bindl still fires with the screen locked.
      flavor = mkOption {
        type = types.enum [
          "bind"
          "binde"
          "bindl"
        ];
        default = "bind";
      };
    };
  };

  widgetType = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      # Waybar's module id; the CSS selector (#custom-<id>) is derived from
      # the same value, so the two can't drift apart.
      id = mkOption { type = types.str; };
      bar = mkOption {
        type = types.enum [
          "left"
          "center"
          "right"
        ];
        default = "right";
      };
      order = mkOption {
        type = types.int;
        default = 50;
      };
      status = mkOption {
        type = types.str;
        default = "status";
      }; # subcommand printing the indicator
      interval = mkOption {
        type = types.int;
        default = 2;
      };
      tooltip = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      onClick = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      onClickRight = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      color = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      margin = mkOption {
        type = types.str;
        default = "0 7px";
      };
      # Escape hatches: waybar has ~40 per-module keys, this models 8 of them.
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = { };
      };
      css = mkOption {
        type = types.lines;
        default = "";
      };
    };
  };

  featureType = types.submodule (
    { name, config, ... }:
    {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        name = mkOption {
          type = types.str;
          default = name;
          readOnly = true;
        };
        source = mkOption {
          type = types.path;
          default = ./scripts + "/${name}.sh";
        };
        runtimeInputs = mkOption {
          type = types.listOf types.package;
          default = [ ];
        };
        # The script's CLI surface, declared rather than inferred: it's what
        # turns a typo'd bind/widget action into an eval error instead of a
        # silent no-op at runtime.
        subcommands = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        binds = mkOption {
          type = types.listOf bindType;
          default = [ ];
        };
        widget = mkOption {
          type = types.nullOr widgetType;
          default = null;
        };
        package = mkOption {
          type = types.package;
          readOnly = true;
        };
      };
      config = {
        widget = lib.mkIf (config.widget != null) { id = lib.mkDefault name; };
        package = pkgs.writeShellApplication {
          inherit (config) name runtimeInputs;
          text = builtins.readFile config.source;
        };
      };
    }
  );

  floatType = types.submodule (
    { name, config, ... }:
    {
      options = {
        class = mkOption {
          type = types.str;
          default = "${name}-float";
        };
        command = mkOption { type = types.str; };
        terminal = mkOption {
          type = types.bool;
          default = true;
        }; # launch inside kitty
        size = mkOption {
          type = types.str;
          default = "800 600";
        };
        launch = mkOption {
          type = types.str;
          readOnly = true;
        }; # reference this, never the class
      };
      config.launch =
        if config.terminal then "kitty --class ${config.class} ${config.command}" else config.command;
    }
  );
in
{
  options.desktop = {
    features = mkOption {
      type = types.attrsOf featureType;
      default = { };
    };
    floats = mkOption {
      type = types.attrsOf floatType;
      default = { };
    };
  };

  config =
    let
      feats = lib.filter (f: f.enable) (lib.attrValues cfg.features);
      withWidget = lib.filter (f: f.widget != null && f.widget.enable) feats;
      floats = lib.attrValues cfg.floats;

      runOf =
        f: args:
        lib.concatStringsSep " " ([ "${f.package}/bin/${f.name}" ] ++ lib.optional (args != "") args);

      onBar = bar: lib.sortOn (f: f.widget.order) (lib.filter (f: f.widget.bar == bar) withWidget);

      toModule =
        f:
        let
          w = f.widget;
        in
        {
          exec = runOf f w.status;
          inherit (w) interval;
          format = "{}";
        }
        // lib.optionalAttrs (w.tooltip != null) { tooltip-format = w.tooltip; }
        // lib.optionalAttrs (w.onClick != null) { on-click = runOf f w.onClick; }
        // lib.optionalAttrs (w.onClickRight != null) { on-click-right = runOf f w.onClickRight; }
        // w.settings;

      toCss =
        f:
        let
          w = f.widget;
        in
        ''
          #custom-${w.id} {
            margin: ${w.margin};${lib.optionalString (w.color != null) "\n  color: ${w.color};"}
          }
          ${w.css}'';

      allBinds = lib.concatMap (
        f: map (b: b // { line = "${b.mods}, ${b.key}, exec, ${runOf f b.run}"; }) f.binds
      ) feats;
      flavored = flavor: map (b: b.line) (lib.filter (b: b.flavor == flavor) allBinds);

      # Every action a bind or widget can fire, so an unknown subcommand fails at eval.
      used =
        f:
        map (b: {
          at = "binds \"${b.mods}, ${b.key}\"";
          inherit (b) run;
        }) f.binds
        ++ lib.optionals (f.widget != null) (
          map
            (a: {
              at = "widget";
              run = a;
            })
            (
              lib.filter (a: a != null) [
                f.widget.status
                f.widget.onClick
                f.widget.onClickRight
              ]
            )
        );
    in
    {
      assertions = lib.concatMap (
        f:
        map (u: {
          assertion = u.run == "" || lib.elem (lib.head (lib.splitString " " u.run)) f.subcommands;
          message =
            "desktop.features.${f.name}: ${u.at} runs unknown subcommand '${u.run}'; "
            + "declared: ${lib.concatStringsSep " " f.subcommands}";
        }) (used f)
      ) feats;

      home.packages = map (f: f.package) feats; # still on PATH for interactive use

      wayland.windowManager.hyprland.settings = {
        bind = lib.mkAfter (flavored "bind");
        binde = lib.mkAfter (flavored "binde");
        bindl = lib.mkAfter (flavored "bindl");
        windowrule = lib.mkAfter (
          lib.concatMap (fl: [
            "float on, match:class ^(${fl.class})$"
            "center on, match:class ^(${fl.class})$"
            "size ${fl.size}, match:class ^(${fl.class})$"
          ]) floats
        );
      };

      programs.waybar.settings.mainBar = lib.mkMerge (
        [
          {
            # mkBefore keeps generated widgets at the head of each bar, matching
            # where the hand-written ones currently sit.
            modules-left = lib.mkBefore (map (f: "custom/${f.widget.id}") (onBar "left"));
            modules-center = lib.mkBefore (map (f: "custom/${f.widget.id}") (onBar "center"));
            modules-right = lib.mkBefore (map (f: "custom/${f.widget.id}") (onBar "right"));
          }
        ]
        ++ map (f: { "custom/${f.widget.id}" = toModule f; }) withWidget
      );

      programs.waybar.style = lib.mkAfter (lib.concatMapStrings toCss withWidget);
    };
}
