let
  height = 1080;
  width = 3840;
in
{
  imports = [
    ../../shared
    ../../wm/hyprland
  ];

  # Has an NVIDIA GPU
  nvidiaSupport = true;

  # Wallpaper path
  wallpaper.generate = {
    enable = true;
    inputSVG = ../../shared/kcorp.svg;
    inherit height width;
  };

  # Monitor
  monitors = [
    {
      name = "DP-2";
      refreshRate = 144;
      primary = true;
      inherit height width;
    }
  ];

  userConfig = {
    global.enable = true;

    programs = {
      browser = {
        librewolf = {
          enable = true;
          defaultBrowser = true;
        };
      };

      editor = {
        vscode.enable = true;
      };
    };
  };
}
