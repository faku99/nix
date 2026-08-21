{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim.extraPlugins = with pkgs.vimPlugins; {
    tiny-inline = {
      package = tiny-inline-diagnostic-nvim;
    };
  };
}
