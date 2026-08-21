{
  den.aspects.nvf.homeManager =
    { pkgs, ... }:
    {
      programs.nvf.settings.vim.extraPlugins.vim-better-whitespace.package = pkgs.vimPlugins.vim-better-whitespace;
    };
}
