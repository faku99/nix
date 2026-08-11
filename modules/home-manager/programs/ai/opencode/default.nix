{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.opencode;

  context = import ../context { inherit lib; };

  omos-version = "v2.2.11";
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

    home.packages = with pkgs; [
      nodejs
      openspec
      uv
      zellij
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
          "opencode-claude-auth@v2.1.6"
          "@ramtinj95/opencode-tokenscope@latest"
          "@simonwjackson/opencode-direnv@latest"
          "@tarquinen/opencode-dcp@latest"
          "oh-my-opencode-slim@${omos-version}"
        ];
        agent = {
          # Use oh-my-opencode-slim agents instead of OpenCode built-ins
          build.disable = true;
          explore.disable = true;
          general.disable = true;
          plan.disable = true;
        };
      };
      tui = {
        plugin = [
          "oh-my-opencode-slim@${omos-version}"
        ];
      };
    };

    home.file.".config/opencode/AGENTS.md".text = context;

    ###########################################################################
    # oh-my-opencode-slim configuration

    home.sessionVariables.OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = true;

    home.file.".config/opencode/oh-my-opencode-slim.json".text = builtins.toJSON {
      "$schema" = "https://unpkg.com/oh-my-opencode-slim@latest/oh-my-opencode-slim.schema.json";

      autoUpdate = false;
      showStartupToast = false;
      setDefaultAgent = true;

      multiplexer = {
        type = "zellij";
      };

      preset = "opencode-go";
      presets = {
        "opencode-go" = {
          orchestrator = {
            model = "opencode-go/minimax-m3";
            variant = "thinking";
          };
          oracle = {
            model = "opencode-go/qwen3.7-max";
            variant = "max";
          };
          librarian = {
            model = "opencode-go/deepseek-v4-flash";
            variant = "high";
            mcps = [
              "context7"
              "gh_grep"
            ];
          };
          explorer = {
            model = "opencode-go/deepseek-v4-flash";
            variant = "high";
          };
          designer = {
            model = "opencode-go/kimi-k2.7-code";
          };
          fixer = {
            model = "opencode-go/deepseek-v4-flash";
            variant = "high";
          };
          observer = {
            model = "opencode-go/mimo-v2.5";
          };
        };
        "anthropic" = {
          orchestrator = {
            model = "anthropic/claude-opus-4-8";
          };
          oracle = {
            model = "anthropic/claude-opus-4-8";
            variant = "high";
          };
          librarian = {
            model = "anthropic/claude-haiku-4-5-20251001";
            mcps = [
              "context7"
              "gh_grep"
            ];
          };
          explorer = {
            model = "anthropic/claude-haiku-4-5-20251001";
          };
          designer = {
            model = "anthropic/claude-sonnet-4-6";
            variant = "medium";
          };
          fixer = {
            model = "anthropic/claude-haiku-4-5-20251001";
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
