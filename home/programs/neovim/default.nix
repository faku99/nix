{config, pkgs, ...}:
let
    inherit (config.userConfig.global) nixConfigDirectory;
    inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
    programs.neovim = {
        enable = true;
        extraConfig = ''
            lua require('init')
        '';
        extraPackages = with pkgs; [
            # General
            delta
            fd
            gnumake
            python3
            ripgrep
            wget

            # C/C++
            clang-tools
            gcc

            # Generic LSP / Formatter
            harper
            nodePackages.cspell
            nodePackages.prettier
            typos-lsp

            # Lua
            lua51Packages.lua
            lua-language-server
            luarocks
            stylua

            # Nix
            nil
            nixd
            nixfmt-rfc-style
        ];
    };

    # Put neovim configuration located in this repository into place in a way that edits to the
    # configuration don't require rebuilding the `home-manager` environment to take effect.
    xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "${nixConfigDirectory}/home/programs/neovim/lua";
}

