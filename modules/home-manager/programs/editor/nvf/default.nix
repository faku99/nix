{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.editor.nvf;
in
{
  options.userConfig.programs.editor.nvf = {
    enable = mkEnableOption "nvf";
  };

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings.vim = {
        viAlias = false;
        vimAlias = false;
        
        options = {
          shiftwidth = 4;
          tabstop = 4;
          wrap = false;
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
            key= "<C-Up>";
            mode = "i";
            action = "<nop>";
            desc = "Use up-arrow key to navigate in insert mode";
          }
          {
            key= "<C-Down>";
            mode = "i";
            action = "<nop>";
            desc = "Use down-arrow key to navigate in insert mode";
          }
          {
            key= "<C-Left>";
            mode = "i";
            action = "<nop>";
            desc = "Use left-arrow key to navigate in insert mode";
          }
          {
            key= "<C-Right>";
            mode = "i";
            action = "<nop>";
            desc = "Use right-arrow key to navigate in insert mode";
          }
          {
            key = "<leader>ff";
            mode = [ "n" ];
            action = "<cmd>Telescope find_files<cr>";
            desc = "Fuzzy-find files by name";
          }
        ];

        theme.enable = true;

        telescope.enable = true;

        lsp.enable = true;

        languages = {
          enableFormat = true;
          enableTreesitter = true;

          nix.enable = true;
          rust.enable = true;
        };
        
        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        visuals = {
          nvim-cursorline.enable = true;
        };
      };
    };
  };
}
