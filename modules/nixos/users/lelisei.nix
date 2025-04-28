{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.nixosConfig.users.lelisei;

  username = "lelisei";

  impermanence = config.nixosConfig.system.impermanence;

  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.nixosConfig.users.${username} = {
    enable = mkEnableOption "User ${username}";

    homeManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable home-manager for this user.";
    };
  };

  config = mkIf cfg.enable {
    nix.settings.trusted-users = [ username ];

    programs.zsh.enable = true;

    users.users.${username} = mkMerge [
      {
        home = mkDefault "/home/${username}";
        isNormalUser = true;
        shell = pkgs.zsh;

        extraGroups = ifGroupExist [
          "docker"
          "networkmanager"
          "wheel"
        ];
      }

      (mkIf impermanence.enable {
        hashedPasswordFile = "${impermanence.persist_dir}/passwords/${username}";
      })
    ];

    home-manager.users = mkIf cfg.homeManager {
      ${username} = import "${self}/users/${username}/${config.networking.hostName}";
    };
  };
}
