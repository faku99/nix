{
  programs.nvf.settings.vim = {
    git = {
      enable = true;
      neogit = {
        enable = true;
      };
    };

    binds.whichKey.register = {
      "<leader>g" = "+Git";
    };
  };
}
