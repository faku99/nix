{ inputs, ... }:
{
  den.aspects.compositor.umbriel = {
    # Only ever include this aspect via `provides.<user>.includes`, never
    # also from a host's bare `includes` list: Den re-resolves an aspect
    # once per distinct list it's referenced from, which would re-run this
    # foreign `imports` and redeclare `programs.umbriel.enable` - the
    # "mutual-provider" battery still flows this `nixos` face up to the
    # host regardless.
    nixos = {
      imports = [ inputs.umbriel.nixosModules.default ];

      programs.umbriel.enable = true;

      services.displayManager.defaultSession = "umbriel";

      services.gnome.gnome-keyring.enable = true;
    };

    homeManager =
      {
        config,
        lib,
        pkgs,
        user,
        ...
      }:
      let
          noctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

          cursorSize =
            if config.stylix.enable or false then toString config.stylix.cursor.size else "32";

          transformNames = [
            "normal"
            "90"
            "180"
            "270"
            "flipped"
            "flipped-90"
            "flipped-180"
            "flipped-270"
          ];

          # Only real DRM connector names port to Umbriel's [output.<name>] -
          # Hyprland's "desc:<EDID>" match syntax has no equivalent, so those
          # monitors are skipped rather than guessed.
          portableMonitors = builtins.filter (m: !lib.hasPrefix "desc:" m.name) (user.monitors or [ ]);
        in
        {
          imports = [ inputs.umbriel.homeModules.default ];

          services.network-manager-applet.enable = true;

          programs.umbriel = {
            enable = true;
            settings = {
              general = {
                mod_key = "Super";
                autostart = [
                  "swaync"
                  (lib.getExe noctalia)
                ];
              };

              environment = {
                CLUTTER_BACKEND = "wayland";
                ELECTRON_OZONE_PLATFORM_HINT = "wayland";
                GDK_BACKEND = "waylandx11,*";
                MOZ_ENABLE_WAYLAND = "1";
                QT_AUTO_SCREEN_SCALE_FACTOR = "1";
                QT_QPA_PLATFORM = "wayland;xcb";
                QT_QPA_PLATFORMTHEME = "qt6ct";
                QT_STYLE_OVERRIDE = "kvantum";
                QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
                SDL_VIDEODRIVER = "wayland";
                XCURSOR_SIZE = cursorSize;
              };

              appearance.blur.radius = 3;

              layout = {
                gap = 3;
                mode = "dwindle";
                dwindle.preserve_split = true;
              };

              input.device = [
                {
                  name = "zsa-technology-labs-moonlander-mark-i";
                  layout = "us";
                  variant = "intl";
                }
              ];

              output = lib.listToAttrs (
                map (m: {
                  name = m.name;
                  value =
                    {
                      mode = "${toString m.width}x${toString m.height}@${toString (m.refreshRate or 60)}";
                      transform = builtins.elemAt transformNames (m.transform or 0);
                    }
                    // lib.optionalAttrs (m ? scale) { scale = m.scale; }
                    // lib.optionalAttrs (m ? position) {
                      position = map lib.toInt (lib.splitString "x" m.position);
                    };
                }) portableMonitors
              );

              keybinds = import ./_binds.nix { inherit lib; };
            };
          };
        };
    };
}
