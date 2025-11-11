{pkgs ? import <nixpkgs> {}, ...}: {
  curseforge = pkgs.callPackage ./curseforge {};
  glide-browser = pkgs.callPackage ./glide-browser {};
  prospect-mail = pkgs.callPackage ./prospect-mail {};
  wallpaper-gen = pkgs.callPackage ./wallpaper-gen {};
}
