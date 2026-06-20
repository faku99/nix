{
  self,
  ...
}:
let
  username = "lelisei";
in
{
  home.username = username;
  home.stateVersion = "26.05";

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
        ssh.enable = true;
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

  programs.zsh.envExtra = ''
    export PATH="$HOME/.nix-profile/bin:$PATH"
  '';
}
