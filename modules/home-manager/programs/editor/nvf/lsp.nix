{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;

      trouble.enable = true;
      lspSignature.enable = true;
      lspconfig.enable = true;
    };

    keymaps = [
      {
        key = "gd";
        mode = "n";
        action = "function() vim.lsp.buf.definition() end";
        desc = "Go to definition";
      }
      {
        key = "gD";
        mode = "n";
        action = "function() vim.lsp.buf.declaration() end";
        desc = "Go to declaration";
      }
      {
        key = "gt";
        mode = "n";
        action = "function() vim.lsp.buf.type_definition() end";
        desc = "Go to type definition";
      }
    ];
  };
}
