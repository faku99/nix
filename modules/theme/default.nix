{ den, inputs, ... }:
let
  base16Scheme = ./gruvbox-dark-modded.yaml;
  image = ./wallpaper.jpg;
  polarity = "dark";

  fonts = {
    serif = {
      package = pkgs: pkgs.nerd-fonts.ubuntu;
      name = "Ubuntu Nerd Font";
    };

    sansSerif = {
      package = pkgs: pkgs.nerd-fonts.ubuntu-sans;
      name = "Ubuntu Nerd Font Sans";
    };

    monospace = {
      package = pkgs: pkgs.nerd-fonts.roboto-mono;
      name = "RobotoMono NerdFont Mono";
    };

    emoji = {
      package = pkgs: pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 12;
      desktop = 11;
      popups = 12;
      terminal = 11;
    };
  };
in
{
  # Single source of truth for theming - the NixOS instance. Home Manager
  # follows it automatically on NixOS hosts (stylix.homeManagerIntegration)
  # and reuses the same values directly on standalone homes (theme-standalone).
  den.aspects.theme.nixos =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;

        inherit base16Scheme image polarity;

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
            package = fonts.serif.package pkgs;
            name = fonts.serif.name;
          };
          sansSerif = {
            package = fonts.sansSerif.package pkgs;
            name = fonts.sansSerif.name;
          };
          monospace = {
            package = fonts.monospace.package pkgs;
            name = fonts.monospace.name;
          };
          emoji = {
            package = fonts.emoji.package pkgs;
            name = fonts.emoji.name;
          };
          inherit (fonts) sizes;
        };
      };
    };

  # Home Manager bits stylix's own nixos->home-manager forwarding doesn't
  # cover (icon/GTK/Qt targets, packages, fontconfig defaults). Applies to
  # NixOS-hosted users (who get the core theme via stylix.homeManagerIntegration)
  # and is also pulled in by theme-standalone for homes with no NixOS host.
  den.aspects.theme-extras.homeManager =
    { config, pkgs, ... }:
    {
      stylix.targets = {
        gtk.enable = true;
        kde.enable = true;
        qt.enable = true;
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

  # Standalone Home Manager (pluto, home-laptop) has no NixOS system to
  # forward from, so it sets up its own stylix instance from the same
  # values declared above.
  den.aspects.theme-standalone = {
    includes = [ den.aspects.theme-extras ];

    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.homeModules.stylix ];

        stylix = {
          enable = true;
          overlays.enable = false;

          inherit base16Scheme image polarity;

          fonts = {
            serif = {
              package = fonts.serif.package pkgs;
              name = fonts.serif.name;
            };
            sansSerif = {
              package = fonts.sansSerif.package pkgs;
              name = fonts.sansSerif.name;
            };
            monospace = {
              package = fonts.monospace.package pkgs;
              name = fonts.monospace.name;
            };
            emoji = {
              package = fonts.emoji.package pkgs;
              name = fonts.emoji.name;
            };
            inherit (fonts) sizes;
          };
        };
      };
  };
}
