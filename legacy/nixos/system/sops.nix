{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixosConfig.system.sops;

  isEd25519 = key: key.type == "ed25519";
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
  keyPaths = map (k: k.path) keys;
in
{
  options.nixosConfig.system.sops = {
    enable = mkEnableOption "sops";
  };

  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = mkIf cfg.enable {
    sops = {
      age = {
        sshKeyPaths = keyPaths;
      };
    };

    environment.systemPackages = with pkgs; [
      age
      sops
      ssh-to-age
    ];
  };
}
