{
  programs.nvf.settings.vim = {
    telescope.enable = true;

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
