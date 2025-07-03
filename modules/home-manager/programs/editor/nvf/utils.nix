{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim = {
    autocomplete = {
      nvim-cmp = {
        enable = true;
        sources = {
          buffer = "[Buffer]";
          nvim-cmp = null;
          path = "[Path]";
        };
        sourcePlugins = [
          pkgs.vimPlugins.cmp-cmdline
        ];
      };
    };

    git = {
      enable = true;
      gitsigns.enable = true;
    };

    notes.todo-comments.enable = true;

    statusline.lualine.enable = true;

    terminal.toggleterm = {
      enable = true;
    };

    utility.motion.flash-nvim.enable = true;
  };
}
