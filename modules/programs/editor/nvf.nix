{
  den.aspects.nvf.homeManager =
    { pkgs, ... }:
    {
      programs.nvf = {
        enable = true;
        settings.vim.package = pkgs.neovim-unwrapped;
      };

      home.sessionVariables = {
        MANPAGER = "nvim -c Man!";
        MANWIDTH = 1000000;
      };

      programs.git.settings = {
        core.pager = "nvim -R";
        color.pager = false;
      };
    };
}
