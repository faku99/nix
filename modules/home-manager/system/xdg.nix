{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.userConfig.system.xdg;
in
{
  options.userConfig.system.xdg = {
    enable = mkEnableOption ''
      XDG Base Directory
      <https://wiki.archlinux.org/title/XDG_Base_Directory>
    '';
  };

  config = mkIf cfg.enable {
    xdg.enable = true;
    xdg.mimeApps.enable = true;

    nix.settings.use-xdg-base-directories = true;
  };
}
