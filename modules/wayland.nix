{
  myConfig.wayland =
    { host, ... }:
    {
      nixos =
        { lib, pkgs, ... }:
        {
          programs = {
            dconf.enable = true;
          };
          environment = {
            systemPackages = with pkgs; [
              wl-clipboard
              waypipe
            ];
            sessionVariables = {
              NIXOS_OZONE_WL = "1";
              XCURSOR_SIZE = lib.mkForce (builtins.ceil (32 * host.primaryDisplay.scaling));
            };
          };
        };

      homeManager =
        { config, ... }:
        {
          qt.enable = true;
          gtk = {
            enable = true;
            gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
            gtk3.bookmarks = [
              "file://${config.home.userDir}/Downloads Downloads"
            ];
          };
        };
    };
}
