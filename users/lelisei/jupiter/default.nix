{
  pkgs,
  ...
}:
{
  home.username = "lelisei";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    fd
  ];

  userConfig = {
    global.enable = true;

    desktop = {
      wayland.enable = true;
    };

    programs = {
      browser = {
        librewolf = {
          enable = true;
          defaultBrowser = true;
        };
      };

      dev = {
        ssh.enable = true;
      };

      editor = {
        neovim = {
          enable = true;
          defaultEditor = true;
        };
        vscode.enable = true;
      };

      misc = {
        claude-desktop.enable = true;
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

      work = {
        enable = true;
      };
    };

    shell = {
      zsh = {
        enable = true;
        defaultShell = true;
      };
    };

    system = {
      impermanence = {
        enable = true;
        directories = [
          "nix"
          "sources"
          "tandem"
        ];
      };
      xdg.enable = true;
      xdgUserDirs.enable = true;
    };
  };
}
