{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
let
  username = "lelisei";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
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
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
  };

  programs = {
    bash.enable = true;
    home-manager.enable = true;
  };

  services = {
    gnome-keyring = {
      enable = false;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
    safeeyes.enable = true;
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
    ../programs/git
    ../programs/gpg
    ../programs/neovim
    ../programs/rbw
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
      atool
      unzip

      git-crypt
      eza # Better 'ls'
      fd # Better 'find'
      ripgrep

      # Nix-related
      # alejandra # Nix formatter
      nixd # Nix LSP
      nil
      nixfmt-rfc-style

      # Shitty webapps mandatory for work
      prospect-mail
      teams-for-linux

      clang-tools

      wine
    ];

    stateVersion = "24.11";
  };

  # Restart services on change
  systemd.user.startServices = "sd-switch";

  # Disable notifications about home-manager news
  news.display = "silent";

  userConfig = {
    global.enable = true;
  };
}
