{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig.networking.openfortivpn;
in
{
  options.nixosConfig.networking.openfortivpn = {
    enable = mkEnableOption "openfortivpn";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      networkmanager-fortisslvpn
      networkmanager-openconnect
      openfortivpn
    ];
  };
}
