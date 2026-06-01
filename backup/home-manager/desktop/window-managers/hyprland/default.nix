{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.userConfig.desktop.windowManager == "hyprland") {
    services = {
      # TODO: Activate only with waybar
      network-manager-applet.enable = true;
    };

    # TODO: Uncomment when stylix is updated for v0.55.0
    stylix.targets.hyprland.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      plugins = [ ];
      settings = {
        bind = import ./binds.nix { inherit lib; };

        curve = [
          {
            _args = [
              "emphasizedAccel"
              {
                type = "bezier";
                points = [
                  [
                    0.3
                    0
                  ]
                  [
                    0.8
                    0.15
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "emphasizedDecel"
              {
                type = "bezier";
                points = [
                  [
                    0.05
                    0.7
                  ]
                  [
                    0.1
                    1
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "standard"
              {
                type = "bezier";
                points = [
                  [
                    0.2
                    0
                  ]
                  [
                    0
                    1
                  ]
                ];
              }
            ];
          }
        ];

        # Animations
        animation = [
          {
            leaf = "layersIn";
            enabled = true;
            speed = 3;
            bezier = "emphasizedDecel";
            style = "slide";
          }
          {
            leaf = "layersOut";
            enabled = true;
            speed = 2;
            bezier = "emphasizedAccel";
            style = "slide";
          }
          {
            leaf = "fadeLayers";
            enabled = true;
            speed = 3;
            bezier = "standard";
          }
          {
            leaf = "windowsIn";
            enabled = true;
            speed = 3;
            bezier = "emphasizedDecel";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 2;
            bezier = "emphasizedAccel";
          }
          {
            leaf = "windowsMove";
            enabled = true;
            speed = 3;
            bezier = "standard";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 3;
            bezier = "standard";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 3;
            bezier = "standard";
          }
          {
            leaf = "fadeDim";
            enabled = true;
            speed = 3;
            bezier = "standard";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 3;
            bezier = "standard";
          }
        ];

        # Window rules
        window_rule = [
          {
            match.class = "(.*)";
            suppress_event = "maximize";
          }
          {
            match = {
              float = true;
              xwayland = false;
            };
            center = true;
          }
        ];

        config = {
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
            };
          };

          dwindle = {
            force_split = 2;
            preserve_split = true;
          };

          ecosystem = {
            no_update_news = true;
          };

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
        };

        env = [
          {
            _args = [
              "CLUTTER_BACKEND"
              "wayland"
            ];
          }
          {
            _args = [
              "ELECTRON_OZONE_PLATFORM_HINT"
              "wayland"
            ];
          }
          {
            _args = [
              "GDK_BACKEND"
              "waylandx11,*"
            ];
          }
          {
            _args = [
              "HYPRCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "MOZ_ENABLE_WAYLAND"
              "1"
            ];
          }
          {
            _args = [
              "QT_AUTO_SCREEN_SCALE_FACTOR"
              "1"
            ];
          }
          {
            _args = [
              "QT_QPA_PLATFORM"
              "wayland;xcb"
            ];
          }
          {
            _args = [
              "QT_QPA_PLATFORMTHEME"
              "qt6ct"
            ];
          }
          {
            _args = [
              "QT_STYLE_OVERRIDE"
              "kvantum"
            ];
          }
          {
            _args = [
              "QT_WAYLAND_DISABLE_WINDOWDECORATION"
              "1"
            ];
          }
          {
            _args = [
              "SDL_VIDEODRIVER"
              "wayland"
            ];
          }
          {
            _args = [
              "XCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "XDG_SESSION_DESKTOP"
              "Hyprland"
            ];
          }
          {
            _args = [
              "XDG_SESSION_TYPE"
              "wayland"
            ];
          }
        ];

        on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''function() hl.exec_cmd("swaync") end'')
            ];
          }
        ];

        monitor = map (m: {
          output = m.name;
          mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = m.position;
          scale = m.scale;
          transform = m.transform;
        }) (config.monitors);
      };

      systemd.variables = [ "--all" ];
      xwayland.enable = true;
    };
  };
}
