{config, ...}: let
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;
in {
  programs.waybar = {
    enable = true;

    settings = [
      {
        position = "top";
        height = 30;
        spacing = 8;
        reload_style_on_change = true;

        # Modules layout
        "modules-left" = [
          "hyprland/workspaces"
        ];
        "modules-center" = [
          "clock"
        ];
        "modules-right" = [
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
          "tray"
          "custom/notification"
        ];

        # Modules configuration
        battery = {
          format = "<span font-family='RobotoMono Nerd Font' weight='bold'>BAT</span> {capacity}%";
          format-time = "{H}h{m}m";
          tooltip = false;
        };
        clock = {
          timezone = "Europe/Zurich";
          locale = "fr_CH.UTF-8";
          interval = 1;
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            on-scroll = 1;
            format = {
              months = "<span color='${colors.base06}'><b>{}</b></span>";
              days = "<span color='${colors.base06}'><b>{}</b></span>";
              weeks = "<span color='${colors.base0A}'><b>W{}</b></span>";
              weekdays = "<span color='${colors.base0B}'><b>{}</b></span>";
              today = "<span color='${colors.base08}'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        cpu = {
          interval = 1;
          format = "<span font-family='RobotoMono Nerd Font' weight='bold'>CPU</span> {usage:02}%";
          tooltip = false;
        };
        "custom/notification" = {
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        "hyprland/workspaces" = {
          format = "{id}";
        };
        memory = {
          interval = 1;
          format = "<span font-family='RobotoMono Nerd Font' weight='bold'>MEM</span> {:02}%";
          tooltip = true;
          tooltip-format = "Used: {used} GiB\nFree: {avail} GiB";
        };
        network = {
          format = "<span font-family='RobotoMono Nerd Font' weight='bold'>NET</span> 󰁝 {bandwidthUpBytes} 󰁅 {bandwidthDownBytes}";
          interval = 1;
          tooltip = false;
        };
        pulseaudio = {
          format = "<span font-family='RobotoMono Nerd Font' weight='bold'>VOL</span> {volume}%";
          format-muted = "<span font-family='RobotoMono Nerd Font' weight='bold'>VOL</span> MUTED";
          tooltip = false;
          on-click = "pavucontrol";
        };
        tray = {
          spacing = 10;
        };
      }
    ];

    systemd = {
      enable = true;
    };

    style = ''
      @define-color color-bg ${colors.base01};
      @define-color color-fg ${colors.base06};

      * {
        font-family: ${fonts.monospace.name};
      }

      window#waybar {
        background-color: @color-bg;
        color: @color-fg;
      }

      button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button {
        color: @color-fg;
        padding: 0 5px;
        border-radius: 0;
        border: none;
        font-weight: bold;
        background: transparent;
      }

      #workspaces button.active {
        background-color: @color-fg;
        color: @color-bg;
      }

      #workspaces button:hover {
        border: none;
        background: ${colors.base06};
        color: @color-bg;
        box-shadow: inherit;
        text-shadow: inherit;
      }

      #workspaces button.urgent {
        background-color: ${colors.base08};
      }

      #clock {
        font-family: ${fonts.sansSerif.name};
        font-weight: bold;
      }

      #cpu,
      #memory,
      #network,
      #tray
      #volume {
        padding: 0 8px;
      }

      #tray {
        margin-right: 4px;
      }
    '';
  };
}
