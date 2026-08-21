{ inputs, ... }:
{
  systems = import inputs.systems;
  imports = [ inputs.den.flakeModule ];
}
