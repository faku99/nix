{
  pkgs,
  config,
  lib,
  ...
}: let
  # inherit (specialArgs) addons;
  # extensions = with addons; [
  # bitwarden
  # ublock-origin
  # ];
  # addons = inputs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox = {
    enable = true;

    package = pkgs.firefox-beta-bin;

    profiles = {
      default = {
        id = 0;
        extensions = with pkgs.inputs.firefox-addons; [
          bitwarden
        ];
      };
    };
  };
}
