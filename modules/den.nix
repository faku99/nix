{ den, inputs, ... }:
{
  systems = import inputs.systems;
  imports = [ inputs.den.flakeModule ];

  # Lets a host's aspect (e.g. den.aspects.saturn) flow its homeManager
  # config down to that host's users, and vice versa.
  den.schema.user.includes = [ den.batteries.mutual-provider ];

  # Hosts pull in their users' own nixos content (accounts, ssh keys)
  den.schema.host.includes = [ den.batteries.user-aspects ];
}
