{ pkgs, ... }:
let
  zsh_custom_path = ".config/oh-my-zsh";
in
{
  home.file = {
    "${zsh_custom_path}/custom.zsh-theme".source = ./custom.zsh-theme;
  };

  programs.zsh = {
    enable = true;

    sessionVariables = {
      CASE_SENSITIVE = true;
      DISABLE_AUTO_TITLE = true;
      DISABLE_UPDATE_PROMPT = true;
      HIST_STAMPS = "yyyy-mm-dd";
    };

    shellAliases = {
      "ls" = "eza -lg --git";
      "la" = "ls -a";
    };

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/${zsh_custom_path}";
      theme = "custom";
      plugins = [
        "git"
        "gitignore"
        "history"
      ];
      extraConfig = ''
        zstyle 'completion:*:default' list-colors ''${(s.:.)LS_COLORS}
        zstyle 'completion:*' special-dirs true
      '';
    };
  };
}
