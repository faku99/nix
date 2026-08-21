# Structure

This flake uses the [dendritic pattern](https://github.com/mightyiam/dendritic) via
[Den](https://github.com/denful/den): `flake-parts` + `import-tree` auto-discover every
`.nix` file under `modules/`, and each file declares one `den.aspects.<name>` covering
both the NixOS and Home Manager sides of a single concern.

```
modules/
  den.nix, default/, formatter.nix, overlays.nix
                          # flake-level wiring, not per-host
  users/lelisei.nix       # den.aspects.lelisei - account, ssh key, sops secret, shell
  hosts/
    saturn/, work-laptop/, pluto/, home-laptop/
                          # each host/home gets its own directory:
                          # den.hosts.<system>.<name> + den.aspects.<name> (NixOS hosts)
                          # den.homes.<system>.<name> (standalone home-manager)
  desktop/, programs/, shell/, system/
                          # feature aspects, one per file (or its own directory
                          # when it has more than one file, e.g. desktop/hyprland/)
```

Add a feature: create `modules/<area>/<name>.nix` with
`den.aspects.<name> = { nixos = {...}; homeManager = {...}; };`, then add it to a
host's `includes` (or `provides.lelisei.includes` for a NixOS host's user - see
`modules/hosts/saturn/default.nix`).

A NixOS host's own `includes`/`homeManager` block does **not** automatically flow to
its users - use `provides.<username>` for that, per Den's
[mutual-provider](https://den.denful.dev/guides/mutual/) mechanism. Standalone
`den.homes` entities don't have this split; their aspect's `includes` applies directly.

# Installation

Every host (NixOS or not) is an age recipient in `.sops.yaml` - after either install
path below, import the GPG key and register the host's age key per `docs/sops.md`,
then rebuild once secrets can decrypt.

## NixOS (saturn, work-laptop)

1. Boot a NixOS installer image. See `docs/fresh_install.md` for wireless bring-up
   (`wpa_cli`) and the Raspberry Pi 5 UEFI steps if relevant.
2. Partition and format disks to match the target host's
   `modules/hosts/<host>/_hardware-configuration.nix` - saturn and work-laptop use
   hand-written `fileSystems` entries, not disko (disko is only wired into the
   currently-unused `impermanence-btrfs` aspect).
3. Install:
   ```
   nixos-install --flake github:faku99/nix#<host>
   ```
4. Reboot and log in as `lelisei` (password set in `modules/users/lelisei.nix`).

## Nix daemon only (pluto, home-laptop)

1. Install Nix on the existing distro (official installer or the Determinate
   Systems installer), with flakes and `nix-command` enabled.
2. Clone this repo.
3. First run (before `home-manager` is on `PATH`):
   ```
   nix run home-manager -- switch --flake github:faku99/nix#<home>
   ```
   Afterwards, `home-manager switch --flake .#<home>` from a local clone.

`home-laptop` runs `targets.genericLinux.nixGL` (see
`modules/hosts/home-laptop/default.nix`) so OpenGL apps work on a non-NixOS
distro - no extra setup needed for that.

# Build

```
nixos-rebuild build --flake .#<host>       # saturn, work-laptop
home-manager build --flake .#<home>        # pluto, home-laptop
```
