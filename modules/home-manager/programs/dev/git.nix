{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.dev.git;
in
{
  options.userConfig.programs.dev.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;

      settings = {
        branch.sort = "-committerdate";
        column.ui = "auto";
        commit.verbose = true;
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        fetch = {
          all = true;
          prune = true;
          pruneTags = true;
        };
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        pull.rebase = true;
        push = {
          autoSetupRemote = true;
          default = "simple";
          followTags = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        rerere = {
          autoUpdate = true;
          enabled = true;
        };
        tag.sort = "version:refname";
        user = {
          name = "Lucas Elisei";
          email = "lucas@elisei.ch";
        };
      };
    };
  };
}
