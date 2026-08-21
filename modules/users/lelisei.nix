{ self, ... }:
let
  username = "lelisei";
  homeDirectory = "/home/${username}";
  userSecretsFile = "${self}/secrets/users/${username}.yaml";
in
{
  den.aspects.lelisei.nixos =
    { config, lib, pkgs, ... }:
    let
      ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    {
      nix.settings.trusted-users = [ username ];
      programs.zsh.enable = true;

      users.users.${username} = {
        home = lib.mkDefault homeDirectory;
        isNormalUser = true;
        shell = pkgs.zsh;

        extraGroups = ifGroupExist [
          "docker"
          "networkmanager"
          "video"
          "wheel"
        ];

        initialHashedPassword = "$y$j9T$Z7neCacyHo.DRe/YK35HL0$HbdjL2Sy1l.yV8Kzoz0mW0Idx0EyzBU7EqG8BAZ3Zj2";

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9YumLqLcxTUgmk0zE5b/CbaEo88yuHbBz3O4VrWefb"
        ];
      };

      sops.secrets."ssh/lelisei_ed25519" = {
        sopsFile = userSecretsFile;
        owner = username;
        path = "${homeDirectory}/.ssh/lelisei_ed25519";
        mode = "0600";
      };
    };
}
