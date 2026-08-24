{ den, ... }:
let
  version = "v2.2.11";
in
{
  den.aspects.oh-my-opencode-slim = {
    includes = [ den.aspects.opencode ];

    homeManager = {
      programs.opencode = {
        settings = {
          plugin = [ "oh-my-opencode-slim@${version}" ];
          agent = {
            # Use oh-my-opencode-slim agents instead of OpenCode built-ins
            build.disable = true;
            explore.disable = true;
            general.disable = true;
            plan.disable = true;
          };
        };
        tui.plugin = [ "oh-my-opencode-slim@${version}" ];
      };

      home.sessionVariables.OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = true;

      home.file.".config/opencode/oh-my-opencode-slim.json".text = builtins.toJSON {
        "$schema" = "https://unpkg.com/oh-my-opencode-slim@latest/oh-my-opencode-slim.schema.json";

        autoUpdate = false;
        showStartupToast = false;
        setDefaultAgent = true;

        multiplexer.type = "zellij";

        preset = "opencode-go";
        presets."opencode-go" = {
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
          designer.model = "opencode-go/kimi-k2.7-code";
          fixer = {
            model = "opencode-go/deepseek-v4-flash";
            variant = "high";
          };
          observer.model = "opencode-go/mimo-v2.5";
        };
      };
    };
  };
}
