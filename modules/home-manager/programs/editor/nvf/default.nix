{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.editor.nvf;
in
{
  options.userConfig.programs.editor.nvf = {
    enable = mkEnableOption "nvf";
  };

  imports = [
    ./keymaps.nix
    ./languages.nix
    ./mini.nix
    ./options.nix
    ./picker.nix
    ./snacks.nix
  ];

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings.vim = {
        theme.enable = true;

        telescope.enable = true;

        visuals = {
          nvim-cursorline.enable = true;
        };
      };
    };
  };
}
