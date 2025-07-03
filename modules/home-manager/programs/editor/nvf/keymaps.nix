{
  programs.nvf.settings.vim = {
    globals.mapleader = " ";

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    keymaps = [
      {
        key = "<Up>";
        mode = [ "n" "v" ];
        action = "<nop>";
        desc = "Disable up-arrow key to force using HJKL";
      }
      {
        key = "<Down>";
        mode = [ "n" "v" ];
        action = "<nop>";
        desc = "Disable down-arrow key to force using HJKL";
      }
      {
        key = "<Left>";
        mode = [ "n" "v" ];
        action = "<nop>";
        desc = "Disable left-arrow key to force using HJKL";
      }
      {
        key = "<Right>";
        mode = [ "n" "v" ];
        action = "<nop>";
        desc = "Disable right-arrow key to force using HJKL";
      }
      {
        key = "<C-K>";
        mode = "i";
        action = "<Up>";
        desc = "Use CTRL+K to navigate in insert mode";
      }
      {
        key= "<C-J>";
        mode = "i";
        action = "<Down>";
        desc = "Use CTRL+J to navigate in insert mode";
      }
      {
        key= "<C-H>";
        mode = "i";
        action = "<Left>";
        desc = "Use CTRL+H to navigate in insert mode";
      }
      {
        key= "<C-L>";
        mode = "i";
        action = "<Right>";
        desc = "Use CTRL+L to navigate in insert mode";
      }
    ];
  };
}
