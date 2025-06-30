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
          tabstop = 4;
          wrap = false;
        };

        keymaps = [
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
