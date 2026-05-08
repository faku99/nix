{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.desktop.wayland.hyprland;
in
{
  options.userConfig.desktop.wayland.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {

    services = {
      hyprpaper.enable = true;
      network-manager-applet.enable = true;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
    };

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
      config.hyprland = {
        default = [
          "wlr"
          "gtk"
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      extraConfig = builtins.readFile ./hyprland.conf;
      plugins = [ ];
      settings = {
        # Custom definitions
        "$menu-rbw" = "rofi-rbw";
        "$mod" = "SUPER";
        "$terminal" = "alacritty";

        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 3, myBezier"
            "windowsOut, 1, 3, default, popin 80%"
            "border, 1, 4, default"
            "borderangle, 0, 8, default"
            "fade, 1, 3, default"
            "workspaces, 1, 4, default"
          ];
        };

        bind = [
          "$mod, D, togglefloating,"
          "$mod, F, fullscreen"

          # Menu bindings
          "$mod, SPACE, exec, $menu"
          "$mod SHIFT, SPACE, exec, $menu-rbw"
          "$mod SHIFT, S, exec, wlogout -b 1"
        ];

        decoration = {
          rounding = 2;
          active_opacity = 1.0;
          inactive_opacity = 0.8;

          blur = {
            enabled = true;
            size = 3;
          };

          shadow = {
            enabled = true;
            # color = rgb colors.base00;
          };
        };

        dwindle = {
          force_split = 2;
          preserve_split = true;
        };

        ecosystem = {
          no_update_news = true;
        };

        env = [
          "CLUTTER_BACKEND,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          "GDK_BACKEND,wayland,x11,*"
          "HYPRCURSOR_SIZE,24"
          "MOZ_ENABLE_WAYLAND,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "QT_STYLE_OVERRIDE,kvantum"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "SDL_VIDEODRIVER,wayland"
          "XCURSOR_SIZE,24"
          "XDG_DATA_DIRS,$HOME/.nix-profile/share:/run/current-system/sw/share"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
        ];

        exec = [
          "hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"
        ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "hyprpaper"
          "swaync"
        ];

        general = {
          allow_tearing = false;
          border_size = 2;
          gaps_in = 3;
          gaps_out = 5;
          layout = "dwindle";
          resize_on_border = false;
        };

        misc = {
          disable_hyprland_logo = true;
          force_default_wallpaper = 1;
        };

        monitor = (map (
          m: "${m.name},${
            if m.enabled
            then "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},${toString m.scale},transform,${toString m.transform}"
            else "disable"
          }"
        ) (config.monitors));
      };

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      xwayland.enable = true;
    };
  };
}
