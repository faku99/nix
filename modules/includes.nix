{ den, ... }:
{
  den.default.includes = [
    den.batteries.hostname
    den.aspects.audio
    den.aspects.openssh
    den.aspects.udev
  ];
}
