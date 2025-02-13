{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rofi-rbw
    wtype # rofi-rbw's dependency
  ];

  programs.rbw = {
    enable = true;
    settings = {
      email = config.secrets.rbw.email;
      base_url = config.secrets.rbw.base_url;
      lock_timeout = 86400;
      sync_interval = 300;
      pinentry = pkgs.pinentry-rofi;
    };
  };
}
