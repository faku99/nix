{
  inputs,
  ...
}: let
  username = "lelisei";
in {
  home.username = username;
  home.stateVersion = "26.05";

  userConfig = {
    global.enable = true;

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
