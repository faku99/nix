{
  den.aspects.nvf.homeManager =
    { pkgs, ... }:
    {
      programs.nvf.settings.vim.extraPlugins.tiny-inline.package = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
    };
}
