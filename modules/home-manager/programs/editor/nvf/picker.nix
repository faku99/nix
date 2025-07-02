{
  programs.nvf.settings.vim = {
    utility = {
      oil-nvim.enable = true;
    };

    keymaps = [
      {
        key = "-";
        mode = "n";
        silent = true;
        action = "<cmd>Oil<cr>";
        desc = "Oil";
      }
    ];
  };
}
