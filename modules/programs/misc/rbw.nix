{
  # ~/.cache/rbw isn't persisted - revisit once the impermanence aspect exists
  den.aspects.rbw.homeManager =
    { config, pkgs, ... }:
    {
      programs.rbw.enable = true;

      # pinentry-tty is needed for login
      home.packages = [ pkgs.pinentry-rofi ];

      sops.secrets."rbw/config_json" = {
        path = "${config.home.homeDirectory}/.config/rbw/config.json";
        mode = "0600";
      };
    };
}
