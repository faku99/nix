{
  config,
  lib,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts; let
  opacity = lib.toHexString (((builtins.ceil (config.stylix.opacity.popups * 100)) * 255) / 100);
  monitor = config.getPrimaryMonitor {};
in {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = monitor.name;
        separator_color = base02;
        font = "${sansSerif.name} ${toString sizes.popups}";
        origin = "top-center";
      };

      urgency_low = {
        background = base01 + opacity;
        foreground = base05;
        frame_color = base0B;
        timeout = 3;
      };

      urgency_normal = {
        background = base01 + opacity;
        foreground = base06;
        frame_color = base02;
        timeout = 5;
      };

      urgency_critical = {
        background = base01 + opacity;
        foreground = base05;
        frame_color = base08;
        timeout = 10;
      };
    };
  };
}
