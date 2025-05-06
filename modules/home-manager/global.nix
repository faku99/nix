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

    home.packages = with pkgs; [
      fd
    ];
  };
}
