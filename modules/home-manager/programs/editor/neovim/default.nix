{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.userConfig.programs.editor.neovim;
in
{
  options.userConfig.programs.editor.neovim = {
    enable = mkEnableOption "neovim";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor.";
    };
  };

  config = mkIf cfg.enable {
    userConfig = {
      system.impermanence = {
        directories = [
          ".cache/nvim"
          ".local/share/nvim"
          ".local/state/nvim"
        ];
      };

      programs.editor = mkIf cfg.defaultEditor {
        enable = true;
        executable = "nvim";
      };
    };

    programs.neovim = {
      enable = true;
      extraConfig = ''
        lua require('init')
      '';
      extraPackages = with pkgs; [
        # Lua
        lua51Packages.lua
        lua52Packages.luarocks
        lua-language-server
        stylua

        # Nix
        nil
        nixd
        nixfmt-rfc-style
      ];
    };

    xdg.configFile = {
      "nvim/lsp".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/modules/home-manager/programs/editor/neovim/lsp";
      "nvim/lua".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/modules/home-manager/programs/editor/neovim/lua";
    };

    home.file = {
      ".local/share/nvim/nvim-treesitter" = {
        recursive = true;
        source = pkgs.symlinkJoin {
          name = "nvim-treesitter-grammars";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };
      };
    };

    home.sessionVariables = {
      MANPAGER = "nvim -c Man!";
      MANWIDTH = 1000000;
    };

    programs.git.extraConfig = {
      core.pager = "nvim -R";
      color.pager = false;
    };
  };
}
