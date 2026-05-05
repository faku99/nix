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

  userConfig = {
    global.enable = true;
    stylix.enable = true;

    desktop = {
      wayland.enable = true;
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
        vscode.enable = true;
      };

      games = {
        curseforge.enable = true;
      };

      misc = {
        libreoffice.enable = true;
        okular.enable = true;
        opencode.enable = true;
        rbw.enable = true;
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
}
