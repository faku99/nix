{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim.extraPlugins = with pkgs.vimPlugins; {
    vim-better-whitespace = {
      package = vim-better-whitespace;
    };
  };
}
