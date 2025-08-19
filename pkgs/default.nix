{pkgs ? import <nixpkgs> {}, ...}: {
  prospect-mail = pkgs.callPackage ./prospect-mail {};
  wallpaper-gen = pkgs.callPackage ./wallpaper-gen {};
}
