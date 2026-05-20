{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.theme;
in
{
  options.userConfig.theme = {
    enable = lib.mkEnableOption "Theme";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      overlays.enable = false;

      image = ./wallpaper.jpg;
      base16Scheme = ./base16-scheme.yaml;
      polarity = "dark";

      fonts = {
        serif = {
          name = "DejaVu Serif";
          package = pkgs.dejavu_fonts;
        };

        sansSerif = {
          name = "DejaVu Sans";
          package = pkgs.dejavu_fonts;
        };

        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };

        emoji = {
          name = "Twitter Color Emoji";
          package = pkgs.twitter-color-emoji;
        };

        sizes = {
          applications = 14;
          desktop = 14;
          popups = 14;
          terminal = 14;
        };
      };

      targets = {
        gtk.enable = true;
        kde.enable = true;
        qt.enable = true;
      };
    };

    home.packages = with pkgs; [
      kdePackages.breeze
      kdePackages.breeze-icons
      twitter-color-emoji
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ config.stylix.fonts.monospace.name ];
        sansSerif = [ config.stylix.fonts.sansSerif.name ];
        serif = [ config.stylix.fonts.serif.name ];
      };
      antialiasing = true;
    };
  };
}
