{
  den.aspects.audio.nixos =
    { pkgs, ... }:
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      environment.systemPackages = [ pkgs.pavucontrol ];
    };
}
