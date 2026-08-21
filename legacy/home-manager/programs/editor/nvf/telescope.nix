{
  programs.nvf.settings.vim = {
    telescope = {
      enable = true;
      setupOpts.defaults = {
        layout_strategy = "horizontal";
        layout_config = {
          horizontal.prompt_position = "bottom";
          horizontal.preview_width = 0.6;
          width = 0.9;
          height = 0.85;
          preview_cutoff = 120;
        };
      };
    };

    keymaps = [
      {
        key = "<leader>ff";
        mode = "n";
        action = "<cmd>Telescope find_files<cr>";
        desc = "Fuzzy-find files by name";
      }
    ];
  };
}
