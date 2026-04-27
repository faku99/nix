{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.userConfig.global;
in
{
  options.userConfig.global = {
    enable = mkEnableOption "Global settings";
  };

  config = mkIf cfg.enable {
    news.display = "silent";

    nix = {
      package = mkDefault pkgs.nix;
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "flakes"
          "nix-command"
        ];

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        trusted-users = [
          "lelisei"
          "root"
        ];
      };
    };

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ inputs.nur.overlays.default ] ++ builtins.attrValues outputs.overlays;
    };

    home.homeDirectory = mkDefault "/home/${config.home.username}";
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

    userConfig = {
      programs.sh-utils.nix-helper.enable = true;
      system = {
        impermanence.directories = [
          ".cache/nix"
          ".gnupg"
        ];
        xdg.enable = true;
      };
    };
  };
}
