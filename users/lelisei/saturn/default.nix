{
  ...
}:
{
  home.username = "lelisei";
  home.stateVersion = "24.11";

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
        git.enable = true;
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
  };
}
