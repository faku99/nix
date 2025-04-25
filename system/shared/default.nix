{
  config,
  outputs,
  pkgs,
  ...
}:
let
  isED25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  sshKeys = builtins.filter isED25519 config.services.openssh.hostKeys;
in
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.roboto-mono
    nerd-fonts.ubuntu
  ];

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Define a user account.
  users.users.lelisei = {
    isNormalUser = true;
    description = "Lucas";
    extraGroups = [
      "docker"
      "sudo"
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
    shell = pkgs.zsh;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ../modules

    # Shared services
    ../services/openssh

    # sops
    outputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.sshKeyPaths = map getKeyPath sshKeys;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    libsecret

    # Work's VPN
    openfortivpn
    networkmanager-fortisslvpn
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  programs = {
    zsh.enable = true;
  };

  # Docker settings
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
