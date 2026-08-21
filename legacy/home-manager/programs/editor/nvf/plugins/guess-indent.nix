{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim.extraPlugins = with pkgs.vimPlugins; {
    guess-indent = {
      package = guess-indent-nvim;
      setup = "require('guess-indent').setup {}";
    };
  };
}
