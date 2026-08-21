{ den, inputs, ... }:
{
  den.homes.x86_64-linux.home-laptop.userName = "lelisei";

  den.aspects.home-laptop = {
    includes = with den.aspects; [
      lelisei
      direnv
      git
      nvf
      okular
      alacritty
      zsh
      glide-browser
    ];

    homeManager = {
      targets.genericLinux = {
        enable = true;
        nixGL = {
          packages = inputs.nix-gl.packages;
          defaultWrapper = "mesa";
          installScripts = [ "mesa" ];
          vulkan.enable = true;
        };
      };
    };
  };
}
