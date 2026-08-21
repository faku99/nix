{ inputs, ... }:
{
  den.aspects.nvf.homeManager =
    { pkgs, ... }:
    {
      imports = [ inputs.nvf.homeManagerModules.default ];

      programs.nvf = {
        enable = true;
        settings.vim.package = pkgs.neovim-unwrapped;
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        MANPAGER = "nvim -c Man!";
        MANWIDTH = 1000000;
      };

      programs.git.settings = {
        core.pager = "nvim -R";
        color.pager = false;
      };
    };
}
