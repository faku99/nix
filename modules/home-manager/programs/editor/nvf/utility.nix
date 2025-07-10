{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim = {
    autocomplete = {
      nvim-cmp = {
        enable = true;
        # sources = {
        #   buffer = "[Buffer]";
        #   nvim-cmp = null;
        #   path = "[Path]";
        # };
        # sourcePlugins = [
        #   pkgs.vimPlugins.cmp-cmdline
        # ];
      };
    };

    notes.todo-comments.enable = true;

    statusline.lualine.enable = true;

    utility = {
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
