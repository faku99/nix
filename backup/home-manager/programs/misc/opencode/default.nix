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
    sops.secrets = {
      "opencode/github_token" = {};
    };

    # Required for installing MCP servers
    home.packages = with pkgs; [
      nodejs_25
      uv
    ];

    # Claude Code is required by opencode-claude-auth plugin
    programs.claude-code.enable = true;

    programs.opencode = {
      enable = true;
      context = ./AGENTS.md;
      enableMcpIntegration = true;
      settings = {
        plugin = [
          "@ex-machina/opencode-anthropic-auth@latest"
          "@ramtinj95/opencode-tokenscope@latest"
          "@simonwjackson/opencode-direnv@latest"
          "@tarquinen/opencode-dcp@latest"
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
              "uvx"
              "mcp-server-git"
            ];
          };
          github = {
            enabled = true;
            type = "remote";
            url = "https://api.githubcopilot.com/mcp/";
            headers = {
              Authorization = "{file:${config.sops.secrets."opencode/github_token".path}}";
            };
          };
          penpot = {
            enabled = true;
            type = "remote";
            url = "http://localhost:4401/mcp";
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

    xdg.configFile = {
      "opencode/agents".source = ./agents;
      "opencode/commands".source = ./commands;
      "opencode/skills".source = ./skills;
    };

    userConfig.system.impermanence = {
      directories = [
        ".local/share/opencode"
      ];
    };
  };
}
