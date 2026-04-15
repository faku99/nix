{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.userConfig.shell.zsh;
in
{
  options.userConfig.shell.zsh = {
    enable = mkEnableOption "zsh";

    defaultShell = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    userConfig.shell = mkIf cfg.defaultShell {
      enable = true;
      executable = "${config.programs.zsh.package}/bin/zsh";
    };

    home.file = {
      ".oh-my-zsh/custom/.keep".text = "";
      ".oh-my-zsh/custom/themes/custom.zsh-theme".source = ./custom.zsh-theme;
    };

    programs.zsh = {
      enable = true;

      dotDir = "${config.xdg.configHome}/zsh";

      sessionVariables = {
        CASE_SENSITIVE = true;
        DISABLE_AUTO_TITLE = true;
        DISABLE_UPDATE_PROMPT = true;
        HIST_STAMPS = "yyyy-mm-dd";
      };

      oh-my-zsh = {
        enable = true;
        custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
        theme = "custom";
        plugins = [
          "direnv"
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

    programs.direnv.enableZshIntegration = true;
  };
}
