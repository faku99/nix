{
  programs.nvf.settings.vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      gitsigns.enabled = true;
      image = {
        enabled = true;
        setupOpts.doc.inline = false;
      };
      statuscolumn.enabled = true;
    };
  };
}
