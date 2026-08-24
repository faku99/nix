{ config, inputs, lib, ... }:
let
  flakeConfig = config;
in
{
  den.default.nixos =
    { pkgs, ... }:
    {
      nixpkgs.overlays = builtins.attrValues flakeConfig.flake.overlays;
      nixpkgs.config = {
        allowUnfree = true;
        segger-jlink.acceptLicense = true;
        permittedInsecurePackages = [ "segger-jlink-qt4-810" ];
      };

      nix = {
        channel.enable = false;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      };
    };

  den.default.homeManager =
    { config, pkgs, ... }:
    {
      nix = {
        package = lib.mkDefault pkgs.nix;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        settings = {
          auto-optimise-store = true;
          experimental-features = [
            "flakes"
            "nix-command"
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://hyprland.cachix.org"
            "https://nix-community.cachix.org"
            "https://noctalia.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
          trusted-users = [
            "lelisei"
            "root"
          ];
        };
      };

      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ inputs.nur.overlays.default ] ++ builtins.attrValues flakeConfig.flake.overlays;
      };
    };
}
