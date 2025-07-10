{
  programs.nvf.settings.vim = {
    terminal = {
      toggleterm = {
        enable = true;
        lazygit = {
          enable = true;
          mappings = {
            open = "<leader>tg";
          };
        };

        mappings = {
          open = "<leader>to";
        };
      };
    };

    keymaps = [
      {
        key = "<esc>";
        mode = "t";
        action = "<C-\\><C-n>";
        desc = "Exit terminal mode";
      }
    ];
  };
}
