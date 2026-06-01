# Migration Plan: Dendritic Pattern for Nix Config

## Context

The current configuration uses a hand-written `flake.nix` with all outputs defined inline, modules split by configuration class (`modules/nixos/` vs `modules/home-manager/`), and manual import lists maintained via `default.nix` aggregators.

The dendritic pattern reorganizes this so that:
- `flake.nix` becomes a thin entry point that almost never changes
- All flake outputs live in auto-discovered `parts/` modules (via `flake-parts` + `import-tree`)
- Modules are organized by **feature** in a unified `features/` directory — NixOS and home-manager config for the same concern live in the same file
- No more manually maintained import lists

**Stack**: `flake-parts` + `import-tree`, keeping `home-manager` (not migrating to hjem).

---

## Phase 1 — Wrap with flake-parts (non-breaking)

**Goal**: Get `flake-parts` in place without changing any module behavior. Every host must still build identically.

### 1.1 Add inputs to `flake.nix`

```nix
flake-parts.url = "github:hercules-ci/flake-parts";
import-tree.url  = "github:vic/import-tree";
```

### 1.2 Restructure `flake.nix`

Replace the `outputs = inputs@{...}: let ... in {...}` block with:

```nix
outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ (inputs.import-tree ./parts) ];
    systems = import inputs.systems;
  };
```

### 1.3 Create `parts/` with one module per current top-level output

Each file is a **flake-parts module** (`{ inputs, config, ... }: { ... }`).

| File | Current output it replaces |
|------|---------------------------|
| `parts/lib.nix` | `lib = nixpkgs.lib // home-manager.lib` |
| `parts/nixpkgs.nix` | `nixpkgsFor`, `inputPkgsFor`, `specialArgs` helpers |
| `parts/formatter.nix` | `formatter = forEachPkgs (pkgs: pkgs.nixfmt)` |
| `parts/packages.nix` | `packages = forAllSystems (system: import ./pkgs …)` |
| `parts/overlays.nix` | `overlays = import ./overlays {…}` |
| `parts/templates.nix` | `templates = import ./templates` |
| `parts/nixos-configurations.nix` | `nixosModules`, `nixosConfigurations`, `nixosConfig` helper |
| `parts/home-configurations.nix` | `homeManagerModules`, `homeConfigurations`, `homeConfig` helper |

Key translation notes:
- `self.outputs.nixosModules` → `config.flake.nixosModules`
- `self.outputs.homeManagerModules` → `config.flake.homeManagerModules`
- `forAllSystems` / `forEachPkgs` are replaced by `perSystem = { pkgs, system, ... }:`
- `specialArgs` helpers move into `parts/nixpkgs.nix` as a `config.flake` attribute or inline into the configuration helpers

**Verify**: `nix flake check`, `nixos-rebuild build --flake .#jupiter`, `home-manager build --flake .#mercury`

---

## Phase 2 — Replace manual import aggregators with import-tree

**Goal**: Remove `modules/nixos/default.nix` and `modules/home-manager/default.nix`. Modules are now auto-discovered.

In `parts/nixos-configurations.nix`, change:
```nix
# before
flake.nixosModules = import ./modules/nixos;

# after
flake.nixosModules = inputs.import-tree ./modules/nixos;
```

Same for `parts/home-configurations.nix`. Delete the two `default.nix` aggregators.

**Note**: Any `default.nix` that re-exports other files via `imports = [...]` can be deleted. Any `default.nix` that contains actual option/config logic must be renamed (e.g. `global.nix` stays, since it has real content — only the empty aggregator files go).

**Verify**: same build commands as Phase 1.

---

## Phase 3 — Migrate modules to feature-based co-location (incremental)

**Goal**: Move from class-based organization (`modules/nixos/`, `modules/home-manager/`) to a unified `features/` directory where each file owns both layers of a concern.

### Feature file anatomy

Each `features/**/<name>.nix` is a **flake-parts module** that exports nixpkgs modules:

```nix
# features/programs/steam.nix
{ ... }:
{
  # NixOS layer
  flake.nixosModules.steam = { config, lib, ... }: {
    options.nixosConfig.programs.steam.enable = lib.mkEnableOption "steam";
    config = lib.mkIf config.nixosConfig.programs.steam.enable {
      programs.steam.enable = true;
    };
  };
  # No home-manager layer needed for steam
}
```

Cross-cutting feature example:
```nix
# features/desktop/hyprland.nix
{ ... }:
{
  flake.nixosModules.hyprland = { ... };        # system install + enable
  flake.homeManagerModules.hyprland = { ... };  # dotfiles / userland config
}
```

### Wire up `features/` in the parts modules

In `parts/nixos-configurations.nix`, aggregate all NixOS feature modules:
```nix
# Replace the static import with import-tree over features/
imports = [ (inputs.import-tree ./features) ];
# Then in nixosConfig helper:
modules = hostModules ++ (builtins.attrValues config.flake.nixosModules);
```

Same pattern for home-manager in `parts/home-configurations.nix`.

### Suggested migration order (simplest → most complex)

**Batch A — NixOS-only leaf modules** (no HM counterpart, move & rename):
- `modules/nixos/programs/steam/` → `features/programs/steam.nix`
- `modules/nixos/networking/caddy.nix` → `features/networking/caddy.nix`
- `modules/nixos/networking/openfortivpn.nix` → `features/networking/openfortivpn.nix`
- `modules/nixos/system/audio.nix` → `features/system/audio.nix`
- `modules/nixos/system/openssh.nix` → `features/system/openssh.nix`
- `modules/nixos/system/udev.nix` → `features/system/udev.nix`
- `modules/nixos/system/nix-ld.nix` → `features/system/nix-ld.nix`
- `modules/nixos/system/sops.nix` → `features/system/sops.nix`

**Batch B — HM-only leaf modules**:
- `modules/home-manager/programs/misc/rbw.nix` → `features/programs/rbw.nix`
- `modules/home-manager/programs/misc/telegram.nix` → `features/programs/telegram.nix`
- `modules/home-manager/programs/sh-utils/{fzf,eza}.nix` → `features/shell/fzf.nix`, `features/shell/eza.nix`
- `modules/home-manager/programs/dev/direnv.nix` → `features/dev/direnv.nix`
- `modules/home-manager/programs/terminal/alacritty.nix` → `features/terminal/alacritty.nix`

**Batch C — Cross-cutting features** (co-locate NixOS + HM):
- fonts: `modules/nixos/global.nix` fonts section + any HM font overrides → `features/system/fonts.nix`
- `modules/nixos/system/impermanence/` + `modules/home-manager/system/impermanence.nix` → `features/system/impermanence.nix`
- `modules/nixos/theme/` + `modules/home-manager/theme/` → `features/theme/stylix.nix`
- `modules/home-manager/programs/dev/git.nix` + any nixos git → `features/dev/git.nix`
- `modules/home-manager/programs/dev/ssh.nix` + `modules/nixos/system/openssh.nix` → `features/system/ssh.nix`

**Batch D — Desktop layer**:
- `modules/nixos/desktop/` + `modules/home-manager/desktop/` →
  - `features/desktop/hyprland.nix`
  - `features/desktop/waybar.nix`
  - `features/desktop/rofi.nix`
  - `features/desktop/monitors.nix`
  - `features/desktop/wallpaper.nix`

**Batch E — Complex features**:
- `modules/home-manager/programs/editor/nvf/` → `features/editor/nvf.nix`
- `modules/home-manager/programs/browser/` → `features/browser/{glide,librewolf,qutebrowser}.nix`
- `modules/home-manager/shell/zsh/` → `features/shell/zsh.nix`
- `modules/nixos/users/lelisei.nix` + `modules/home-manager/global.nix` → keep as-is or `features/users/lelisei.nix`

**After each batch**: verify the affected hosts still build before moving on.

---

## Phase 4 — Migrate global config modules (final cleanup)

Move `modules/nixos/global.nix` and `modules/home-manager/global.nix` into features (or keep as `features/global.nix` and `features/global-home.nix`). At this point, `modules/nixos/` and `modules/home-manager/` should be empty and can be deleted.

Update `parts/nixos-configurations.nix` and `parts/home-configurations.nix` to stop importing from `modules/` entirely — all modules now come from `features/` via import-tree.

---

## Critical files

| File | Role in migration |
|------|-------------------|
| `flake.nix` | Becomes thin entry point in Phase 1 |
| `modules/nixos/default.nix` | Deleted in Phase 2 |
| `modules/home-manager/default.nix` | Deleted in Phase 2 |
| `modules/nixos/global.nix` | Migrated last (Phase 4) |
| `modules/home-manager/global.nix` | Migrated last (Phase 4) |
| `parts/` | Created in Phase 1, extended in later phases |
| `features/` | Created in Phase 3 |

---

## Verification per phase

- **Phase 1 & 2**: `nix flake check` + `nixos-rebuild build --flake .#jupiter` + `nixos-rebuild build --flake .#saturn` + `home-manager build --flake .#mercury`
- **Phase 3 (each batch)**: build all affected hosts/users after each batch
- **All phases**: `nix flake show` should display the same output structure throughout
