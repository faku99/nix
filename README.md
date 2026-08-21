# Structure

This flake uses the [dendritic pattern](https://github.com/mightyiam/dendritic) via
[Den](https://github.com/denful/den): `flake-parts` + `import-tree` auto-discover every
`.nix` file under `modules/`, and each file declares one `den.aspects.<name>` covering
both the NixOS and Home Manager sides of a single concern.

```
modules/
  den.nix, default.nix, formatter.nix, overlays.nix
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

# Build

```
nixos-rebuild build --flake .#<host>       # saturn, work-laptop
home-manager build --flake .#<home>        # pluto, home-laptop
```
