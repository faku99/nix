{ den, inputs, ... }:
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
        tui = "fullscreen";
        theme = "dark";
        enabledPlugins = {
          "clangd-lsp@claude-plugins-official" = true;
        };
        statusLine = {
          type = "command";
          command = "ccstatusline";
        };
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
      "ccstatusline-settings.json" = builtins.toJSON {
        version = 3;
        lines = [
          [
            {
              id = "1";
              type = "current-working-dir";
              color = "cyan";
              rawValue = true;
              metadata.abbreviateHome = "true";
            }
            {
              id = "5324e8b4-6a67-4e45-be99-12c6e8757935";
              type = "flex-separator";
            }
            {
              id = "5";
              type = "git-branch";
              color = "magenta";
              rawValue = true;
            }
            {
              id = "088776f2-1a79-409d-939a-2ab879aa21cd";
              type = "custom-text";
              customText = " ";
            }
            {
              id = "7";
              type = "git-changes";
              color = "yellow";
              metadata.hideNoGit = "false";
            }
          ]
          [
            {
              id = "8f94c06c-ed4c-4570-ac0c-0946053e22df";
              type = "model";
            }
            {
              id = "dc43fda8-fab7-4713-bc65-db3809cf7f10";
              type = "separator";
            }
            {
              id = "941502f3-2566-4f3e-93d5-a9d38b69eae0";
              type = "context-length";
              rawValue = true;
            }
            {
              id = "9242e9cc-328e-4dae-bf2e-8433f2d91541";
              type = "flex-separator";
            }
            {
              id = "22b93e0e-b8c2-4064-8b60-9059975464cb";
              type = "session-usage";
              rawValue = false;
            }
            {
              id = "f41eceb6-0cf1-4f78-98a2-9a5bc1b7b4f8";
              type = "separator";
            }
            {
              id = "83b016f7-74e2-4f2a-b6a1-631d742ad421";
              type = "weekly-usage";
            }
          ]
          [ ]
        ];
        flexMode = "full-minus-40";
        compactThreshold = 60;
        colorLevel = 2;
        defaultPaddingSide = "both";
        inheritSeparatorColors = false;
        globalBold = false;
        gitCacheTtlSeconds = 5;
        minimalistMode = false;
        powerline = {
          enabled = false;
          separators = [ "" ];
          separatorInvertBackground = [ false ];
          startCaps = [ ];
          endCaps = [ ];
          autoAlign = false;
          continueThemeAcrossLines = false;
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
        inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline
        # used by the settings.json Notification/Stop hooks
        pkgs.libnotify
        pkgs.jq
      ];
      home.file.".claude/CLAUDE.md".text = files."CLAUDE.md";
      home.file.".claude/settings.json".text = files."settings.json";
      # ccstatusline's own config lives outside CLAUDE_CONFIG_DIR, shared by both claude and claude-work
      home.file.".config/ccstatusline/settings.json".text = files."ccstatusline-settings.json";
    };

  den.aspects.claude-code-work = {
    includes = [ den.aspects.claude-code ];

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
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
