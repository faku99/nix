{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkForce mkIf;
  cfg = config.nixosConfig.system.openssh;

  impermanence = config.nixosConfig.system.impermanence;
in
{
  options.nixosConfig.system.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    nixosConfig.system.impermanence = {
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };

      # Auto-generate host keys
      hostKeys = mkForce [
        {
          path = "${lib.optionalString impermanence.enable impermanence.persist_dir}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
