{ inputs, ... }:
{
  den.aspects.openlogi.nixos = {
    # FIXME: remove when nixpkgs' programs.openlogi catches up with the flake
    disabledModules = [ "programs/openlogi.nix" ];
    imports = [ inputs.openlogi.nixosModules.default ];

    programs.openlogi = {
      enable = true;
      launchAtLogin = true;
    };
  };
}
