{
  config,
  pkgs,
  ...
}: let
  monitor = config.getPrimaryMonitor {};
in {
  home.packages = with pkgs; [
    hyprlock
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = false;
      };

      background = {
        monitor = monitor.name;
        path = builtins.toString config.wallpaper.path;
      };

      animations = {
        enabled = false;
      };

      input-field = {
        size = "200, 50";
        position = "0, -200";
        monitor = monitor.name;
        dots_center = false;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(91, 96, 120)";
        outer_color = "rgb(24, 25, 38)";
        outline_thickness = 2;
        placeholder_text = "";
      };
    };
  };
}
