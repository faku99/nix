{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig.system.udev;
in
{
  options.nixosConfig.system.udev = {
    segger = mkEnableOption "SEGGER J-Link udev rules";
  };

  config = mkIf cfg.segger {
    services.udev.packages = with pkgs; [
      segger-jlink
    ];
  };
}
