{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.userConfig.programs.editor.nvf;
in
{
  options.userConfig.programs.editor.nvf = {
    enable = mkEnableOption "nvf";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor.";
    };
  };

  imports = [
    ./plugins
    ./comments.nix
    ./formatter.nix
    ./git.nix
    ./keymaps.nix
    ./languages.nix
    ./lsp.nix
    ./options.nix
    ./statusline.nix
    ./telescope.nix
    ./terminal.nix
    ./ui.nix
    ./utility.nix
    ./visuals.nix
  ];

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings.vim.package = pkgs.neovim-unwrapped;
    };

    userConfig.programs.editor = mkIf cfg.defaultEditor {
      enable = true;
      executable = "nvim";
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
