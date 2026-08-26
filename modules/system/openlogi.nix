{ inputs, ... }:
{
  den.aspects.openlogi.nixos = {
    imports = [ inputs.openlogi.nixosModules.default ];

    programs.openlogi.enable = true;
  };
}
