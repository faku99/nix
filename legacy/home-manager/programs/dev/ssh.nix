{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.dev.ssh;
in
{
  options.userConfig.programs.dev.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    userConfig.system.impermanence = {
      directories = [ ".ssh" ];
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          HostName = "ssh.github.com";
          Port = 443;
          User = "git";
        };
      };
    };
  };
}
