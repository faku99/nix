{config, ...}: let
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;
in {
  programs.waybar = {
    enable = true;

    settings = [
      {
        position = "top";
        include = ["${./config.jsonc}"];
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
