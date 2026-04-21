{pkgs ? import <nixpkgs> {}, ...}: {
  curseforge = pkgs.callPackage ./curseforge {};
  wallpaper-gen = pkgs.callPackage ./wallpaper-gen {};
}
