{ inputs, ... }:
{
  den.aspects.noctalia = {
    nixos = {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      programs.noctalia.recommendedServices.enable = true;
    };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in
      {
        imports = [ inputs.noctalia.homeModules.default ];

        home.sessionVariables = {
          DESKTOP_LAUNCHER = "${lib.getExe noctalia} msg panel-toggle launcher";
          DESKTOP_POWERMENU = "${lib.getExe noctalia} msg panel-toggle session";
        };

        wayland.windowManager.hyprland.settings.on = [
          {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''function() hl.exec_cmd("${lib.getExe noctalia}") end'')
            ];
          }
        ];

        programs.noctalia = {
          enable = true;
          package = noctalia;

          settings = {
            theme = {
              source = "custom";
              custom_palette = "stylix";
            };

            shell = {
              avatar_path = "/home/lelisei/.face";
              corner_radius_scale = 0.3;
              time_format = "{:%H:%M}";
              date_format = "%A %d %B";
              show_location = false;
              clipboard_enabled = true;

              launcher.categories = false;

              session = {
                grid = false;
                actions = [
                  {
                    action = "reboot";
                    shortcut = "1";
                  }
                  {
                    action = "shutdown";
                    shortcut = "2";
                  }
                  {
                    action = "command";
                    label = "Reboot to UEFI";
                    command = "systemctl reboot --firmware-setup";
                    shortcut = "3";
                  }
                ];
              };
            };

            wallpaper.directory = "/home/lelisei/Pictures/Wallpapers";

            weather = {
              enabled = true;
              effects = false;
            };

            location = {
              address = "Lausanne, Switzerland";
              auto_locate = false;
            };

            control_center.calendar.show_week_numbers = true;

            dock.enabled = false;

            bar.main = {
              capsule = false;
              radius = 0;
              scale = 1.2;
              margin_ends = 0;
              widget_spacing = 16;

              capsule_radius = 4;

              font_family = lib.mkForce config.stylix.fonts.monospace.name;

              start = [
                "launcher"
                "workspaces"
              ];
              center = [ "clock" ];
              end = [
                "tray"
                "media"
                "volume"
                "sysmon_cpu_usage"
                "sysmon_cpu_temp"
                "sysmon_ram_used"
                "sysmon_net_rx"
                "sysmon_net_tx"
                "network"
                "notifications"
                "session"
              ];

              dead_zone.actions.middle = "settings-toggle";
            };

            widget = {
              workspaces = {
                focused_color = "primary";
                hide_when_empty = false;
                label_source = "id";
                max_label_chars = 2;
                occupied_color = config.lib.stylix.colors.withHashtag.base05;
                show_all_outputs = false;
                show_labels = true;
              };

              clock = {
                format = "{:%Y-%m-%d %H:%M}";
                vertical_format = "{:%H:%M} - {:%Y-%m-%d}";
                tooltip_format = "{:%Y-%m-%d %H:%M:%S}";
                color = "primary";
              };

              tray = {
                drawer = true;
                hide_passive = true;
              };

              media = {
                hide_album_art = false;
                hide_when_no_media = true;
                title_scroll = "on_hover";
              };

              sysmon_cpu_usage = {
                type = "sysmon";
                stat = "cpu_usage";
                visualization = "none";
              };
              sysmon_cpu_temp = {
                type = "sysmon";
                stat = "cpu_temp";
                visualization = "none";
              };
              sysmon_ram_used = {
                type = "sysmon";
                stat = "ram_used";
                visualization = "none";
              };
              sysmon_net_rx = {
                type = "sysmon";
                stat = "net_rx";
                network_speed_compact = true;
                visualization = "none";
              };
              sysmon_net_tx = {
                type = "sysmon";
                stat = "net_tx";
                network_speed_compact = true;
                visualization = "none";
              };

              network = {
                show_label = false;
              };

              notifications = {
                hide_when_no_unread = true;
              };

              session = {
                icon_color = "error";
              };
            };
          };
        };
      };
  };
}
