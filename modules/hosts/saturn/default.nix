{ den, inputs, ... }:
{
  den.hosts.x86_64-linux.saturn.users.lelisei = {
    classes = [ "homeManager" ];
    monitors = [
      {
        name = "DP-2";
        width = 2560;
        height = 1440;
        refreshRate = 144;
        primary = true;
      }
      {
        name = "DP-3";
        width = 2560;
        height = 1440;
        transform = 1;
      }
    ];
  };

  den.aspects.saturn = {
    # NixOS-only aspects - applied directly to this host.
    includes = [
      den.aspects.steam
      den.aspects.sops
      den.aspects.networkmanager
      den.aspects.docker
      den.aspects.hyprland
    ];

    nixos =
      { lib, ... }:
      {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
          ./_hardware-configuration.nix
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-gpu-amd
        ];

        boot.initrd.kernelModules = [ "amdgpu" ];
        boot.kernelParams = [
          "usbcore.autosuspend=-1"
          "xhci_hcd.power_efficient=0"
        ];
        boot.extraModprobeConfig = ''
          # Solve mouse lag???
          options drm_kms_helper poll=N
        '';

        boot.loader = {
          grub = {
            enable = true;
            useOSProber = true;
            device = "nodev";
            efiSupport = true;
          };
          systemd-boot.enable = lib.mkForce false;
          efi.canTouchEfiVariables = true;
        };
        boot.supportedFilesystems = [ "nfs" ];

        services.displayManager.autoLogin = {
          enable = true;
          user = "lelisei";
        };

        hardware = {
          amdgpu.opencl.enable = true;
          bluetooth.enable = true;
        };
      };

    # Everything below is scoped to lelisei on this host (Host -> User
    # mutual-provider), since a host's own includes/homeManager block
    # doesn't automatically flow down to its users.
    provides.lelisei = {
      includes = [
        den.aspects.theme
        den.aspects.hyprland
        den.aspects.noctalia
        den.aspects.xdg

        den.aspects.claude-code
        den.aspects.claude-code-work
        den.aspects.oh-my-opencode-slim

        den.aspects.brave
        den.aspects.glide-browser-default

        den.aspects.direnv
        den.aspects.git
        den.aspects.ssh

        den.aspects.nvf
        den.aspects.vscode

        den.aspects.dolphin
        den.aspects.libreoffice
        den.aspects.okular
        den.aspects.rbw
        den.aspects.telegram

        den.aspects.eza
        den.aspects.nix-helper

        den.aspects.alacritty

        den.aspects.zsh
      ];

      homeManager.wayland.windowManager.hyprland.settings.device = [
        {
          name = "zsa-technology-labs-moonlander-mark-i";
          kb_layout = "us";
          kb_variant = "intl";
        }
      ];
    };
  };
}
