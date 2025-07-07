{
  programs.nvf.settings.vim = {
    terminal = {
      toggleterm = {
        enable = true;

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
      {
        key = "<C-h>";
        mode = "t";
        action = "<C-\\><C-n><C-w><C-h>";
        desc = "Navigate to left window";
      }
      {
        key = "<C-j>";
        mode = "t";
        action = "<C-\\><C-n><C-w><C-j>";
        desc = "Navigate to bottom window";
      }
      {
        key = "<C-k>";
        mode = "t";
        action = "<C-\\><C-n><C-w><C-k>";
        desc = "Navigate to top window";
      }
      {
        key = "<C-l>";
        mode = "t";
        action = "<C-\\><C-n><C-w><C-l>";
        desc = "Navigate to right window";
      }
    ];
  };
}
