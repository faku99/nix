{
  programs.nvf.settings.vim = {
    git = {
      enable = true;
      neogit = {
        enable = true;
        mappings.open = "<leader>g";
        setupOpts = {
          kind = "vsplit";
          commit_editor.staged_diff_split_kind = "vsplit";
          commit_select_view.kind = "vsplit";
          integrations = {
            telescope = true;
            diffview = true;
          };
        };
      };
    };

    binds.whichKey.register = {
      "<leader>g" = "+Git";
    };
  };
}
