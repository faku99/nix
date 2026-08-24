{
  den.aspects.nvf.homeManager =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixfmt
      ];

      programs.nvf.settings.vim = {
        lsp = {
          enable = true;

          trouble.enable = true;
          lspSignature.enable = true;
          lspconfig.enable = true;

          presets = {
            clangd.enable = true;
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
              cmd = lib.mkForce [
                "qmlls"
                "-E"
              ];
              filetypes = [ "qml" ];
              settings.qmlls = {
                profile = "Qt6";
                qmlImportPaths = [ "$QML_IMPORT_PATH" ];
              };
            };
            nixd = {
              enable = true;
              filetypes = [ "nix" ];
              root_markers = [
                "flake.nix"
                ".git"
              ];
              settings = {
                nil.nix.flake.autoArchive = true;
                nixd = {
                  formatting.command = [ "nixfmt" ];
                  nixpkgs.expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }";
                };
              };
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
    };
}
