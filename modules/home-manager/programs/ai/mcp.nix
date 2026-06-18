{ inputs, ... }:
{
  imports = [
    inputs.mcp-servers-nix.homeManagerModules.default
  ];

  programs.mcp.enable = true;

  mcp-servers.programs = {
    context7.enable = true;
  };
}
