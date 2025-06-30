{
  config,
  lib,
  ...
}:
let
  cfg = config.userConfig.programs.editor;
in
{
  imports = [
    ./neovim
    ./nvf
    ./vscode
  ];

  options.userConfig.programs.editor = {
    enable = lib.mkEnableOption "Editor";
    executable = lib.mkOption {
      type = lib.types.str;
      example = "nvim";
      description = "Executable path";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = cfg.executable;
    };
  };
}
