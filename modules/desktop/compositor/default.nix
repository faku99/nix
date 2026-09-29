{
  # Guard against a host accidentally including more than one - independent
  # of Den's own aspect machinery, just the final merged NixOS config.
  den.default.nixos =
    { config, lib, ... }:
    {
      assertions = [
        {
          assertion =
            lib.count lib.id [
              (config.programs.hyprland.enable or false)
              (config.programs.umbriel.enable or false)
            ] <= 1;
          message = "Choose at most one of den.aspects.compositor.{hyprland,umbriel} per host.";
        }
      ];
    };
}
