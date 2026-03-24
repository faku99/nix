{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.opencode;
in
{
  options.userConfig.programs.misc.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    # Required for MCP servers
    home.packages = with pkgs; [
      nodejs_25
    ];

    # Claude Code is required by opencode-claude-auth plugin
    programs.claude-code.enable = true;

    programs.opencode = {
      enable = true;
      settings = {
        plugin = [
          "opencode-claude-auth@latest"
        ];
        mcp = {
          filesystem = {
            enabled = true;
            type = "local";
            command = [
              "npx"
              "-y"
              "@modelcontextprotocol/server-filesystem"
              "."
            ];
          };
          git = {
            enabled = true;
            type = "local";
            command = [
              "npx"
              "-y"
              "mcp-server-git"
            ];
          };
          rg = {
            enabled = true;
            type = "local";
            command = [
              "npx"
              "-y"
              "mcp-ripgrep"
            ];
          };
        };
      };
    };

    userConfig.system.impermanence = {
      directories = [
        ".local/share/opencode"
      ];
    };
  };
}
