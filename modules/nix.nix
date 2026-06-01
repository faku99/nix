{
  den.default = {
    nixos =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        nix = {
          package = pkgs.lixPackageSets.latest.lix;
          gc.automatic = true;
          settings = {
            auto-optimise-store = true;
            use-xdg-base-directories = true;
          };
        };
      };
  };
}
