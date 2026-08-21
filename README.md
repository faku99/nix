# Structure

This flake uses the [dendritic pattern](https://github.com/mightyiam/dendritic) via
[Den](https://github.com/denful/den): `flake-parts` + `import-tree` auto-discover every
`.nix` file under `modules/`, and each file declares one `den.aspects.<name>` covering
both the NixOS and Home Manager sides of a single concern.

# Installation

Every host (NixOS or not) is an age recipient in `.sops.yaml` - after either install
path below, import the GPG key and register the host's age key per `docs/sops.md`,
then rebuild once secrets can decrypt.

## NixOS

1. Boot a NixOS installer image. See `docs/iso-wifi.md` for wireless bring-up
   inside installation ISO.
2. Partition and format disks to match the target host's
   `modules/hosts/<host>/_hardware-configuration.nix`
3. Install:
   ```
   nixos-install --flake github:faku99/nix#<host>
   ```
4. Reboot

## Nix daemon only

1. Install Nix on the existing distro
2. Clone this repo.
3. First run
   ```
   nix run home-manager -- switch --flake github:faku99/nix#<home>
   ```
   Afterwards, `home-manager switch --flake .#<home>` from a local clone.

