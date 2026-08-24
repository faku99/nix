{ inputs, ... }:
{
  # Unused by any current host (both saturn and work-laptop run without it).
  # Extra persisted paths: add to environment.persistence.main.{directories,files}
  # from the host or program aspect that needs them - lists merge automatically.
  den.aspects.impermanence.nixos =
    { config, ... }:
    let
      persistDir = "/persistent";
      isUser = user: user.group == "users";
      users = builtins.filter isUser (builtins.attrValues config.users.users);
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      fileSystems.${persistDir}.neededForBoot = true;

      boot.tmp = {
        useTmpfs = true;
        cleanOnBoot = true;
      };

      users.mutableUsers = false;

      environment.persistence.main = {
        persistentStoragePath = persistDir;
        hideMounts = true;

        directories = [
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/log"
        ];

        files = [ "/etc/machine-id" ];
      };

      systemd.tmpfiles.rules = map (
        user: "d ${persistDir}/${user.home} 0700 ${user.name} ${user.group} - -"
      ) users;
    };
}
