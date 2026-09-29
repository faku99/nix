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
              (config.services.displayManager.sddm.enable or false)
              (config.services.displayManager.noctalia-greeter.enable or false)
            ] <= 1;
          message = "Choose at most one of den.aspects.displayManager.{sddm,noctalia-greeter} per host.";
        }
      ];
    };
}
