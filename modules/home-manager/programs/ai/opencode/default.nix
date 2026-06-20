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
      "opencode/github_token" = { };
      "api-keys/opencode-go" = { };
    };

    # Required for installing MCP servers
    home.packages = with pkgs; [
      nodejs
      uv
    ];

    # Claude Code is required by opencode-claude-auth plugin
    programs.claude-code.enable = true;

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        provider = {
          opencode-go.options.apiKey = "{file:${config.sops.secrets."api-keys/opencode-go".path}}";
        };
        plugin = [
          "@ex-machina/opencode-anthropic-auth@latest"
          "@ramtinj95/opencode-tokenscope@latest"
          "@simonwjackson/opencode-direnv@latest"
          "@tarquinen/opencode-dcp@latest"
          "oh-my-opencode-slim"
        ];
        #mcp = {
        #  filesystem = {
        #    enabled = true;
        #    type = "local";
        #    command = [
        #      "npx"
        #      "-y"
        #      "@modelcontextprotocol/server-filesystem"
        #      "."
        #    ];
        #  };
        #  git = {
        #    enabled = true;
        #    type = "local";
        #    command = [
        #      "uvx"
        #      "mcp-server-git"
        #    ];
        #  };
        #  github = {
        #    enabled = true;
        #    type = "remote";
        #    url = "https://api.githubcopilot.com/mcp/";
        #    headers = {
        #      Authorization = "{file:${config.sops.secrets."opencode/github_token".path}}";
        #    };
        #  };
        #  rg = {
        #    enabled = true;
        #    type = "local";
        #    command = [
        #      "npx"
        #      "-y"
        #      "mcp-ripgrep"
        #    ];
        #  };
        #};
      };
    };

    home.file.".config/opencode/AGENTS.md".text = builtins.readFile ./AGENTS.md;

    ###########################################################################
    # oh-my-opencode-slim configuration

    home.sessionVariables.OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = true;

    home.file.".config/opencode/oh-my-opencode-slim.json".text = builtins.toJSON {
      "$schema" = "https://unpkg.com/oh-my-opencode-slim@latest/oh-my-opencode-slim.schema.json";

      autoUpdate = false;
      showStartupToast = false;
      setDefaultAgent = true;

      preset = "opencode-go";
      presets = {
        "opencode-go" = {
          orchestrator = {
            model = "opencode-go/glm-5.1";
            skills = [ "*" ];
            mcps = [
              "*"
              "!context7"
            ];
          };
          oracle = {
            model = "opencode-go/deepseek-v4-pro";
            variant = "max";
            skills = [
              "refactor-plan"
              "simplify"
            ];
            mcps = [ ];
          };
          council = {
            model = "opencode-go/deepseek-v4-pro";
            variant = "high";
          };
          librarian = {
            model = "opencode-go/minimax-m2.7";
            skills = [ ];
            mcps = [
              "websearch"
              "context7"
              "gh_grep"
              "github"
            ];
          };
          explorer = {
            model = "opencode-go/minimax-m2.7";
            skills = [ "context-map" ];
            mcps = [ ];
          };
          designer = {
            model = "opencode-go/kimi-k2.6";
            variant = "medium";
          };
          fixer = {
            model = "opencode-go/deepseek-v4-flash";
            variant = "high";
            skills = [
              "refactor"
              "git-commit"
            ];
            mcps = [ ];
          };
          observer = {
            model = "opencode-go/kimi-k2.6";
          };
        };
      };

      disabled_mcps = [ "context7" ];
    };

    #xdg.configFile = {
    #  "opencode/agents".source = ./agents;
    #  "opencode/commands".source = ./commands;
    #  "opencode/skills".source = ./skills;
    #};

    userConfig.system.impermanence = {
      directories = [
        ".local/share/opencode"
      ];
    };
  };
}
