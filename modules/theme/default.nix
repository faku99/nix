{ inputs, ... }:
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

  resolveFonts = pkgs: {
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
in
{
  # Single source of truth for theming - the NixOS instance.
  #
  # On a NixOS host, home-manager users inherit it automatically via
  # stylix's own nixos->home-manager forwarding. Standalone homes (no
  # NixOS host, e.g. pluto) have no host to forward from, so they build
  # their own stylix instance from the same values declared above -
  # `home` is only non-null in that case (see Den's home entity: a
  # host's user gets { host, user }, a standalone home gets { home }).
  den.aspects.theme =
    { home ? null, ... }:
    {
      nixos =
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

            fonts = resolveFonts pkgs;
          };
        };

      homeManager =
        { config, lib, pkgs, ... }:
        lib.recursiveUpdate
          (lib.optionalAttrs (home != null) {
            imports = [ inputs.stylix.homeModules.stylix ];
            stylix = {
              enable = true;
              overlays.enable = false;
              inherit base16Scheme image polarity;
              fonts = resolveFonts pkgs;
            };
          })
          {
            # Not covered by stylix's nixos->home-manager forwarding.
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
    };
}
