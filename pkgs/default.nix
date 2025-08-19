{pkgs ? import <nixpkgs> {}, ...}: {
  curseforge = pkgs.callPackage ./curseforge {};
  prospect-mail = pkgs.callPackage ./prospect-mail {};
  wallpaper-gen = pkgs.callPackage ./wallpaper-gen {};
}
