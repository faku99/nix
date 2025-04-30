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
    mkOption
    types
    ;

  cfg = config.nixosConfig.users.lelisei;

  username = "lelisei";

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

    users.users.${username} = {
      home = mkDefault "/home/${username}";
      isNormalUser = true;
      shell = pkgs.zsh;

      extraGroups = ifGroupExist [
        "docker"
        "networkmanager"
        "wheel"
      ];

      initialHashedPassword = "$y$j9T$Z7neCacyHo.DRe/YK35HL0$HbdjL2Sy1l.yV8Kzoz0mW0Idx0EyzBU7EqG8BAZ3Zj2";
    };

    home-manager.users = mkIf cfg.homeManager {
      ${username} = import "${self}/users/${username}/${config.networking.hostName}";
    };
  };
}
