{config, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [
        (builtins.toString config.wallpaper.path)
      ];

      wallpaper = [
        ",${builtins.toString config.wallpaper.path}"
      ];
    };
  };
}
