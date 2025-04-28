{
  config,
  lib,
  pkgs,
  outputs,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.nixosConfig.global;
in
{
  options.nixosConfig.global = {
    enable = mkEnableOption "Global system settings";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
    };

    environment.systemPackages = with pkgs; [
      git
    ];

    nix = {
      # Disable channel since we use flakes
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    # Needed by home-manager
    programs.dconf.enable = true;

    # Enable ssh by default
    nixosConfig.system.openssh.enable = mkDefault true;

    # Enable theming
    nixosConfig.theme.enable = true;
  };
}
