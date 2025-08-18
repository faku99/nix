{
  ...
}:
{
  programs.nvf.settings.vim = {
    autocomplete = {
      nvim-cmp = {
        enable = true;
      };
    };

    notes.todo-comments.enable = true;

    statusline.lualine.enable = true;

    utility = {
      diffview-nvim.enable = true; # For neogit

      motion.flash-nvim.enable = true;

      oil-nvim = {
        enable = true;
        setupOpts = {
          view_options.case_insensitive = true;
        };
      };
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
