{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.userConfig.shell.zsh;

  zsh_custom_path = ".config/oh-my-zsh";
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
  };
}
