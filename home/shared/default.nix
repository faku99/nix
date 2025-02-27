{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  username = "lelisei";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      flake-registry = ""; # Disable global flake registry
    };
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
  };

  programs = {
    bash.enable = true;
    home-manager.enable = true;
  };

  services = {
    gnome-keyring = {
      enable = false;
      components = ["pkcs11" "secrets" "ssh"];
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays; # ++ [outputs.vscode-extensions.overlays.default];
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ../modules

    # Shared programs
    ../programs/alacritty
    ../programs/firefox
    ../programs/git
    ../programs/gpg
    ../programs/rbw
    ../programs/vscodium
    ../programs/zsh

    # Shared services
    ../services/dunst
    ../services/gpg-agent

    # stylix
    outputs.stylix.homeManagerModules.stylix
  ];

  xdg = {
    inherit configHome;
    enable = true;
  };

  home = {
    inherit username homeDirectory;

    # Shared packages that don't need specific configuration
    packages = with pkgs; [
      git-crypt
      eza # Better 'ls'
      fd # Better 'find'

      # Nix-related
      alejandra # Nix formatter
      nixd # Nix LSP

      # Shitty webapps mandatory for work
      prospect-mail
      teams-for-linux
    ];

    stateVersion = "24.11";
  };

  # Restart services on change
  systemd.user.startServices = "sd-switch";

  # Disable notifications about home-manager news
  news.display = "silent";
}
