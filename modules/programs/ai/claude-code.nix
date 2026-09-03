{ den, ... }:
let
  homeFiles =
    { lib, pkgs }:
    let
      notifySend = lib.getExe' pkgs.libnotify "notify-send";
      jq = lib.getExe pkgs.jq;
      title = ''"Claude Code — $(basename "$PWD")"'';
    in
    {
      "CLAUDE.md" = import ./_context { inherit lib; };
      "settings.json" = builtins.toJSON {
        hooks = {
          # Notification fires on permission prompts and idle-waiting-for-input.
          Notification = [
            {
              hooks = [
                {
                  type = "command";
                  command = ''${notifySend} -a 'Claude Code' ${title} "$(${jq} -r '.message // "Action required"')" 2>/dev/null || true'';
                }
              ];
            }
          ];
          Stop = [
            {
              hooks = [
                {
                  type = "command";
                  command = ''${notifySend} -a 'Claude Code' ${title} "Response complete" 2>/dev/null || true'';
                }
              ];
            }
          ];
        };
      };
    };
in
{
  den.aspects.claude-code.homeManager =
    { lib, pkgs, ... }:
    let
      files = homeFiles { inherit lib pkgs; };
    in
    {
      home.packages = [
        pkgs.claude-code
        # used by the settings.json Notification/Stop hooks
        pkgs.libnotify
        pkgs.jq
      ];
      home.file.".claude/CLAUDE.md".text = files."CLAUDE.md";
      home.file.".claude/settings.json".text = files."settings.json";
    };

  den.aspects.claude-code-work = {
    includes = [ den.aspects.claude-code ];

    homeManager =
      { config, lib, pkgs, ... }:
      let
        workConfigDir = ".claude-work";
        files = homeFiles { inherit lib pkgs; };
      in
      {
        home.packages = [
          (pkgs.writeShellScriptBin "claude-work" ''
            export CLAUDE_CONFIG_DIR="${config.home.homeDirectory}/${workConfigDir}"
            exec "${pkgs.claude-code}/bin/claude" "$@"
          '')
        ];

        home.file."${workConfigDir}/CLAUDE.md".text = files."CLAUDE.md";
        home.file."${workConfigDir}/settings.json".text = files."settings.json";
      };
  };
}
