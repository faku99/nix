{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig.programs.wine;
in
{
  options.nixosConfig.programs.wine = {
    enable = mkEnableOption "wine";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # (wineWowPackages.full.override {
      #   wineRelease = "staging";
      #   mingwSupport = true;
      # })
      wine-staging
      winetricks
    ];
  };
}
