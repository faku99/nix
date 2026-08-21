{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.ai.opencode;

  context = import ../context { inherit lib; };

  oh-my-opencode-slim-version = "v2.2.11";
in
{
  options.userConfig.programs.ai.opencode = {
    enable = mkEnableOption "opencode";

    oh-my-opencode-slim = {
      enable = lib.mkEnableOption "oh-my-opencode-slim";
    };
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

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        provider = {
          opencode-go.options.apiKey = "{file:${config.sops.secrets."api-keys/opencode-go".path}}";
        };
        plugin = [
          "@ramtinj95/opencode-tokenscope@latest"
          "@simonwjackson/opencode-direnv@latest"
          "@tarquinen/opencode-dcp@latest"
        ] ++ lib.lists.optionals cfg.oh-my-opencode-slim.enable [
          "oh-my-opencode-slim@${oh-my-opencode-slim-version}"
        ];
        agent = lib.mkIf cfg.oh-my-opencode-slim.enable {
          # Use oh-my-opencode-slim agents instead of OpenCode built-ins
          build.disable = true;
          explore.disable = true;
          general.disable = true;
          plan.disable = true;
        };
      };
      tui = lib.mkIf cfg.oh-my-opencode-slim.enable {
        plugin = [
          "oh-my-opencode-slim@${oh-my-opencode-slim-version}"
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
      };
    };

    userConfig.system.impermanence = {
      directories = [
        ".config/opencode"
        ".local/share/opencode"
      ];
    };
  };
}
