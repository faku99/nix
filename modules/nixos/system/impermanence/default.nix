{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.nixosConfig.system.impermanence;

  isUser = user: user.group == "users";
  users = builtins.filter isUser (builtins.attrValues config.users.users);
in
{
  options.nixosConfig.system.impermanence = {
    enable = mkEnableOption "Impermanence setup";

    persist_dir = mkOption {
      type = types.str;
      default = "/persistent";
      description = "The directory in which persistent data is stored.";
    };

    files = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
      description = "List of files to store persistently.";
    };

    directories = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
      description = "List of directories to store persistently";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of users to store persistently";
    };
  };

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./btrfs.nix
  ];

  config = mkIf cfg.enable {
    fileSystems = {
      ${cfg.persist_dir}.neededForBoot = true;
    };

    boot.tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };

    users.mutableUsers = false;

    # Default persistent files
    environment.persistence.main = {
      persistentStoragePath = cfg.persist_dir;
      hideMounts = true;

      directories = cfg.directories ++ [
        # "/etc/ssh"
        # "/nix"
        "/var/lib/nixos"
        # "/var/lib/private"
        "/var/lib/systemd"
        "/var/log"
        # "/var/tmp"
      ];

      files = cfg.files ++ [ "/etc/machine-id" ];

      users = lib.genAttrs cfg.users (
        username:
        let
          homeImper = config.home-manager.users.${username}.userConfig.system.impermanence;
        in
        mkIf homeImper.enable {
          directories = homeImper.directories;
          files = homeImper.files;
        }
      );
    };

    # Create persistent home directory
    systemd.tmpfiles = {
      rules = map (user: "d ${cfg.persist_dir}/${user.home} 0700 ${user.name} ${user.group} - -") users;
    };
  };
}
