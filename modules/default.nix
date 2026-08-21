{
  config,
  den,
  inputs,
  lib,
  ...
}:
let
  flakeConfig = config;
in
{
  den.default = {
    includes = [
      den.batteries.hostname
      den.aspects.audio
      den.aspects.openssh
      den.aspects.udev
    ];

    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = builtins.attrValues flakeConfig.flake.overlays;
        nixpkgs.config = {
          allowUnfree = true;
          segger-jlink.acceptLicense = true;
          permittedInsecurePackages = [ "segger-jlink-qt4-810" ];
        };

        system.stateVersion = "26.05";

        environment.systemPackages = with pkgs; [ git ];
        fonts.packages = with pkgs; [ font-awesome ];

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

        time.timeZone = "Europe/Zurich";
        programs.dconf.enable = true;
        services.gvfs.enable = true;
        services.printing = {
          enable = true;
          drivers = [ pkgs.gutenprint ];
        };
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };

        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_MEASUREMENT = "fr_CH.UTF-8";
            LC_MONETARY = "fr_CH.UTF-8";
            LC_NUMERIC = "fr_CH.UTF-8";
            LC_PAPER = "fr_CH.UTF-8";
          };
        };

        security.sudo.wheelNeedsPassword = false;
      };

    homeManager =
      { config, pkgs, ... }:
      {
        news.display = "silent";

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

        home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
        home.stateVersion = "26.05";
        home.packages = with pkgs; [
          atool
          fd
          ripgrep
          unzip
        ];

        programs = {
          gpg.enable = true;
          home-manager.enable = true;
        };
      };
  };
}
