{
  config,
  lib,
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
    ./keymaps.nix
    ./languages.nix
    ./mini.nix
    ./options.nix
    ./picker.nix
    ./snacks.nix
    ./telescope.nix
    ./terminal.nix
    ./ui.nix
    ./utils.nix
    ./visuals.nix
  ];

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
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
