{ den, ... }:
{
  den.aspects.claude-code-work = {
    includes = [ den.aspects.claude-code ];

    homeManager =
      { config, lib, pkgs, ... }:
      let
        workConfigDir = ".claude-work";
      in
      {
        home.packages = [
          (pkgs.writeShellScriptBin "claude-work" ''
            export CLAUDE_CONFIG_DIR="${config.home.homeDirectory}/${workConfigDir}"
            exec "${pkgs.claude-code}/bin/claude" "$@"
          '')
        ];

        home.file."${workConfigDir}/CLAUDE.md".text = import ./_context { inherit lib; };
      };
  };
}
