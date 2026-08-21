{ den, ... }:
{
  # Monitors are freeform per-user context (den.hosts.<system>.<host>.users.<user>.monitors = [ { ... } ]),
  # consumed by the desktop aspects that need them (hyprland).
  den.default.includes = [ den.aspects.monitors ];

  den.aspects.monitors =
    { user, ... }:
    {
      homeManager =
        { lib, ... }:
        {
          assertions = [
            {
              assertion =
                (user.monitors or [ ]) == [ ]
                || (lib.length (lib.filter (m: m.primary or false) user.monitors)) == 1;
              message = "Exactly one monitor must be set to primary.";
            }
          ];
        };
    };
}
