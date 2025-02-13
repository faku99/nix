{pkgs, ...}: let
  height = 1440;
  width = 2560;
in {
  imports = [
    ../../shared
    ../../wm/hyprland
  ];

  # Packages specific to this host
  home.packages = [
    pkgs.wallpaper-gen
    pkgs.steam-run
    pkgs.transmission_4-qt
  ];

  # Wallpaper
  wallpaper.generate = {
    enable = true;
    inputSVG = ../../shared/kcorp.svg;
    inherit height width;
  };

  # Monitor
  monitors = [
    {
      inherit height width;
      name = "DP-3";
      refreshRate = 144;
      primary = true;
    }
  ];
}
