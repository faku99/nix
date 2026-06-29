{
  self,
  ...
}: let
  username = "lelisei";
in {
  home.username = username;
  home.stateVersion = "26.05";

  sops = {
    gnupg.home = "/home/${username}/.gnupg";
    defaultSopsFile = "${self}/secrets/users/${username}.yaml";
  };

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

  userConfig = {
    global.enable = true;
    theme.enable = true;

    desktop = {
      windowManager = "hyprland";

      shell = "noctalia";
    };

    programs = {
      browser = {
        brave.enable = true;
        glide-browser = {
          enable = true;
          defaultBrowser = true;
        };
      };

      dev = {
        direnv.enable = true;
        git.enable = true;
        ssh.enable = true;
      };

      editor = {
        nvf = {
          enable = true;
          defaultEditor = true;
        };
      };

      misc = {
        dolphin.enable = true;
        okular.enable = true;
        opencode.enable = true;
      };

      sh-utils = {
        eza.enable = true;
        nix-helper.enable = true;
      };

      terminal = {
        alacritty = {
          enable = true;
          defaultTerminal = true;
        };
      };
    };

    shell = {
      zsh = {
        enable = true;
        defaultShell = true;
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "zsa-technology-labs-moonlander-mark-i";
        kb_layout = "us";
        kb_variant = "intl";
      }
    ];
  };
}
