{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.ai.claude-code;

  context = import ../context { inherit lib; };

  workConfigDir = ".claude-work";
in
{
  options.userConfig.programs.ai.claude-code = {
    enable = mkEnableOption "claude-code";

    work.enable = mkEnableOption "work profile";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
    ] ++ lib.optional cfg.work.enable (
      pkgs.writeShellScriptBin "claude-work" ''
        export CLAUDE_CONFIG_DIR="${config.home.homeDirectory}/${workConfigDir}"
        exec "${pkgs.claude-code}/bin/claude" "$@"
      ''
    );

    home.file = {
      ".claude/CLAUDE.md".text = context;
    } // lib.optionalAttrs cfg.work.enable {
      "${workConfigDir}/CLAUDE.md".text = context;
    };

    userConfig.system.impermanence.directories = [
      ".claude"
    ] ++ lib.optional cfg.work.enable workConfigDir;
  };
}
