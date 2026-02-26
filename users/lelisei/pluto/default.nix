{
  ...
}:
{
  home.username = "lelisei";
  home.stateVersion = "26.05";

  userConfig = {
    global.enable = true;

    programs = {
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

      sh-utils = {
        eza.enable = true;
        nix-helper.enable = true;
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
