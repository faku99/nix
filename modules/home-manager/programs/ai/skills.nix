{ inputs, ... }:
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;
    sources = {
      oh-my-opencode-slim = {
        path = inputs.oh-my-opencode-slim;
        subdir = "src/skills";
      };
    };
    skills.enable = [
      # oh-my-opencode-slim
      # See: https://github.com/alvinunreal/oh-my-opencode-slim/blob/master/docs/skills.md
      "clonedeps"
      "codemap"
      "deepwork"
      "reflect"
      "simplify"
      "worktrees"
    ];
    targets.agents.enable = true;
  };
}
