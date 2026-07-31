{
  inputs,
  self,
  ...
}: let
  username = "lelisei";
in {
  home.username = username;
  home.stateVersion = "26.05";

  targets.genericLinux = {
    enable = true;
    nixGL = {
      packages = inputs.nix-gl.packages;
      defaultWrapper = "mesa";
      installScripts = ["mesa"];
      vulkan.enable = true;
    };
  };

  sops = {
    gnupg.home = "/home/${username}/.gnupg";
    defaultSopsFile = "${self}/secrets/users/${username}.yaml";
  };

  userConfig = {
    global.enable = true;
    theme.enable = true;

    programs = {
      dev = {
        direnv.enable = true;
        git.enable = true;
      };

      editor = {
        nvf = {
          enable = true;
          defaultEditor = true;
        };
      };

      misc = {
        opencode.enable = true;
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
