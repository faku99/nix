{ den, ... }:
{
  # Monitors are freeform host/user context (e.g. den.hosts.<system>.<host>.monitors = [ { ... } ]),
  # consumed by the desktop aspects that need them (hyprland, wallpaper).
  den.default.includes = [ den.aspects.monitors ];

  den.aspects.monitors =
    { host, user, ... }:
    {
      nixos =
        { lib, ... }:
        {
          assertions = [
            {
              assertion =
                (host.monitors or [ ]) == [ ] || (lib.length (lib.filter (m: m.primary) host.monitors)) == 1;
              message = "Exactly one monitor must be set to primary.";
            }
          ];
        };

      homeManager =
        { lib, ... }:
        {
          assertions = [
            {
              assertion =
                (user.monitors or [ ]) == [ ] || (lib.length (lib.filter (m: m.primary) user.monitors)) == 1;
              message = "Exactly one monitor must be set to primary.";
            }
          ];
        };
    };
}
