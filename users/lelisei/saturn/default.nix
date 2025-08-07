{
  self,
  ...
}:
let
  username = "lelisei";
in
{
  home.username = username;
  home.stateVersion = "24.11";

  sops = {
    gnupg.home = "/home/${username}/.gnupg";
    defaultSopsFile = "${self}/secrets/users/${username}.yaml";
  };

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
        battle-net.enable = true;
      };

      misc = {
        claude-desktop.enable = true;
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
