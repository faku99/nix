{
  den,
  myConfig,
  ...
}:
{
  myConfig.hyprland = {
    includes = [
      myConfig.wayland
      #den.lib.perHost
      #  (
      #      {host, ... }:
      #      {
      #          homeManager = { pkgs, config, ... }: { # TODO: Monitors
      # }}) host.displays;};}
    ];

    nixos = {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      services = {
        greetd.settings.default_session.user = "lelisei";
        greetd.settings.default_session.name = "hyprland-uwsm";

        gnome.gnome-keyring.enable = true;
      };
    };
  };
}
