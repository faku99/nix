{
  inputs,
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

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      primary = true;
    }
  ];

  userConfig = {
    global.enable = true;

    desktop = {
      wayland.enable = true;
    };

    programs = {
      browser = {
        glide-browser.enable = true;
      };

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
        okular.enable = true;
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
