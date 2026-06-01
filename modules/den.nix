{
  den,
  inputs,
  ...
}:
{
  den.schema.user.includes = [ den.batteries.mutual-provider ];
  flake.den = den;
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "myConfig" false)
  ];
}
