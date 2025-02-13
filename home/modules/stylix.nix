{
  config,
  pkgs,
  ...
}: let
  opacity = 0.95;
  fontSize = 12;
in {
  stylix = {
    enable = true;
    polarity = "dark";
    autoEnable = false;

    image = config.wallpaper;

    base16Scheme = {
      system = "base16";
      name = "atelier-lakeside";
      author = "Bram de Haan (http://atelierbramdehaan.nl)";
      variant = "dark";
      palette = {
        base00 = "161b1d"; # Default background
        base01 = "1f292e"; # Lighter background (used for status bars)
        base02 = "516d7b"; # Selection background
        base03 = "5a7b8c"; # Comments, invisibles, line highlighting
        base04 = "7195a8"; # Dark foreground (used for status bars)
        base05 = "7ea2b4"; # Default foreground
        base06 = "c1e4f6"; # Light foreground
        base07 = "ebf8ff"; # Light background
        base08 = "d22d72";
        base09 = "935c25";
        base0A = "8a8a0f";
        base0B = "568c3b";
        base0C = "2d8f6f";
        base0D = "257fad";
        base0E = "6b6bb8";
        base0F = "b72dd2";
      };
    };

    opacity = {
      terminal = opacity;
      popups = opacity;
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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = fontSize;
        desktop = fontSize;
        popups = fontSize;
        terminal = fontSize;
      };
    };
  };
}
