{ inputs, ... }:
{
  den.aspects.theme = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];

        stylix = {
          enable = true;

          base16Scheme = ./gruvbox-dark-modded.yaml;
          polarity = "dark";

          opacity = {
            applications = 1.0;
            desktop = 1.0;
            popups = 0.9;
            terminal = 0.9;
          };

          cursor = {
            package = pkgs.phinger-cursors;
            name = "phinger-cursors";
            size = 24;
          };

          fonts = {
            serif = {
              package = pkgs.nerd-fonts.ubuntu;
              name = "Ubuntu Nerd Font";
            };

            sansSerif = {
              package = pkgs.nerd-fonts.ubuntu-sans;
              name = "Ubuntu Nerd Font Sans";
            };

            monospace = {
              package = pkgs.nerd-fonts.roboto-mono;
              name = "RobotoMono NerdFont Mono";
            };

            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };

            sizes = {
              applications = 12;
              desktop = 11;
              popups = 12;
              terminal = 11;
            };
          };
        };
      };

    homeManager =
      { config, lib, pkgs, ... }:
      {
        imports = [ inputs.stylix.homeModules.stylix ];

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

        home.packages = [
          pkgs.kdePackages.breeze
          pkgs.kdePackages.breeze-icons
          pkgs.twitter-color-emoji
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
  };
}
