{pkgs, ...}: {
  programs.git = {
    enable = true;

    extraConfig = {
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret";
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
    };

    userName = "Lucas Elisei";
  };
}
