{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig.theme;
in
{
  options.nixosConfig.theme = {
    enable = mkEnableOption "Theme";
  };

  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = mkIf cfg.enable {
    stylix = {
      enable = true;

      # image = config.nixosConfig.desktop.wallpaper.path;
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
}
