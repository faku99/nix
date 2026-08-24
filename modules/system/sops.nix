{ inputs, ... }:
{
  den.aspects.sops.nixos =
    { config, pkgs, ... }:
    let
      isEd25519 = key: key.type == "ed25519";
      keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops.age.sshKeyPaths = map (k: k.path) keys;

      environment.systemPackages = with pkgs; [
        age
        sops
        ssh-to-age
      ];
    };
}
