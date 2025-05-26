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
        experimental-features = [
          "flakes"
          "nix-command"
        ];
      };
    };

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ inputs.nur.overlays.default ] ++ builtins.attrValues outputs.overlays;
    };

    home.homeDirectory = mkDefault "/home/${config.home.username}";
    home.packages = with pkgs; [
      fd
      ripgrep
    ];

    programs = {
      gpg.enable = true;
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
