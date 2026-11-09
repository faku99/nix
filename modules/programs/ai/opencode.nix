{
  den.aspects.opencode.homeManager =
    { config, lib, pkgs, ... }:
    {
      sops.secrets = {
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
          provider.opencode-go.options.apiKey = "{file:${config.sops.secrets."api-keys/opencode-go".path}}";
          plugin = [
            "@simonwjackson/opencode-direnv@latest"
          ];
        };
      };

      home.file.".config/opencode/AGENTS.md".text = import ./_context { inherit lib; };
    };
}
