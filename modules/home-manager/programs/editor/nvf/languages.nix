{
  lib,
  ...
}:
{
  programs.nvf.settings.vim = {
    diagnostics = {
      enable = true;

      config = {
        signs = {
          text = {
            "vim.diagnostic.severity.Error" = " ";
            "vim.diagnostic.severity.Warn" = " ";
            "vim.diagnostic.severity.Hint" = " ";
            "vim.diagnostic.severity.Info" = " ";
          };
        };
        underline = true;
        update_in_insert = true;
        virtual_text = {
          format =
            lib.generators.mkLuaInline
            # lua
            ''
              function(diagnostic)
                return string.format('%s', diagnostic.message)
              end
            '';
        };
      };
      nvim-lint = {
        enable = true;
      };
    };

    syntaxHighlighting = true;

    treesitter = {
      enable = true;

      autotagHtml = true;
      context.enable = true;
      highlight.enable = true;
    };

    lsp = {
      enable = true;

      trouble.enable = true;
      lspSignature.enable = true;
      lspconfig.enable = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;

      clang.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = true;
      tailwind.enable = true;
      ts.enable = true;
    };
  };
}
