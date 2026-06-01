{
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;

      trouble.enable = true;
      lspSignature.enable = true;
      lspconfig.enable = true;

      presets = {
        clangd.enable = true;
        nixd.enable = true;
        qmlls.enable = true;
        tailwindcss-language-server.enable = true;
      };

      servers = {
        clangd = {
          enable = true;
          filetypes = [
            "c"
            "cpp"
          ];
        };
        qmlls = {
          enable = true;
          filetypes = [ "qml" ];
        };
        nixd = {
          enable = true;
          settings.nix.flake.autoArchive = true;
          filetypes = [ "nix" ];
        };
      };
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
