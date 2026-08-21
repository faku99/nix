{ den, inputs, ... }:
{
  den.hosts.x86_64-linux.work-laptop.users.lelisei = {
    classes = [ "homeManager" ];
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
      }
      {
        name = "DP-4";
        width = 1920;
        height = 1080;
        primary = true;
        position = "auto-left";
      }
    ];
  };

  den.aspects.work-laptop = {
    # NixOS-only aspects - applied directly to this host.
    includes = [
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
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
        ];

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

        time.hardwareClockInLocalTime = false;

        # NFS server for RPi development
        services.nfs.server = {
          enable = true;
          exports = ''
            /srv          10.0.0.0/24(rw,no_root_squash,no_subtree_check,fsid=root,crossmnt)
            /srv/proto_v0 10.0.0.0/24(rw,no_subtree_check,no_root_squash)
          '';
        };

        networking.firewall = {
          enable = true;
          interfaces."enp60s0u1u3" = {
            allowedTCPPorts = [
              111
              2049
              4000
              4001
              4002
              20048
            ];
            allowedUDPPorts = [
              111
              2049
              4000
              4001
              4002
              20048
            ];
          };
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

        den.aspects.dolphin
        den.aspects.okular

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
