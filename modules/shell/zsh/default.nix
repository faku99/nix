{ den, ... }:
{
  den.aspects.zsh = {
    includes = [ den.aspects.fzf ];

    homeManager =
      { config, lib, pkgs, ... }:
      let
        coreUtilsAliases = lib.mapAttrs (name: value: lib.mkDefault value) {
          ls = "ls -l --color=always --group-directories-first";
          cp = "cp -iv";
          mv = "mv -iv";
          rm = "rm -iv";
          cht = "cht.sh";
        };
      in
      {
        home.file = {
          ".oh-my-zsh/custom/.keep".text = "";
          ".oh-my-zsh/custom/themes/custom.zsh-theme".source = ./custom.zsh-theme;
        };

        home.sessionVariables.SHELL = "${config.programs.zsh.package}/bin/zsh";
        home.packages = with pkgs; [
          cht-sh
          eza
        ];
        home.shellAliases = coreUtilsAliases;

        programs.bash.shellAliases = coreUtilsAliases;
        programs.zsh = {
          enable = true;
          shellAliases = coreUtilsAliases;
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
  };
}
