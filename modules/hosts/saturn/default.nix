{
  inputs,
  myConfig,
  ...
}:
{
  den.hosts.x86_64-linux.saturn = {
    users.lelisei.classes = [ "homeManager" ];

    # TODO: displays
  };

  den.aspects.saturn = {
    includes = with myConfig; [
      desktop
    ];

    nixos = {
      imports = with inputs; [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd
      ];

      boot.loader.grub.device = "/dev/disk/by-uuid/B588-EA6F";

      hardware = {
        amdgpu.opencl.enable = true;
        bluetooth.enable = true;
        facter.reportPath = ./facter.json;
      };

      networking = {
        hostName = "saturn";
      };
    };
  };
}
