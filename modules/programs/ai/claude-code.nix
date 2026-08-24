{
  den.aspects.claude-code.homeManager =
    { lib, pkgs, ... }:
    {
      home.packages = [ pkgs.claude-code ];
      home.file.".claude/CLAUDE.md".text = import ./_context { inherit lib; };
    };
}
