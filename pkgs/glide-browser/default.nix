{
  pkgs,
  stdenv,
  fetchurl,
  makeWrapper,
  lib,
}: let
  buildInputs = [
    stdenv.cc.cc.lib
    pkgs.gcc.libc
    pkgs.glibc
    pkgs.libgcc
  ];
  libraryPath = lib.makeLibraryPath buildInputs;

  version = "0.1.53a";
in
  stdenv.mkDerivation {
    pname = "glide-browser";
    inherit version;

    src = fetchurl {
      url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-x86_64.tar.xz";
      sha256 = "sha256-tU+o6YKtlOX9rDQBS8OJOv3NNlk/mM14keIHDVPO5Ec=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    buildInputs = buildInputs;

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib/glide
      tar xf $src --directory=$out/lib/glide --strip-components=1
      chmod +x $out/lib/glide/glide-bin

      makeWrapper $out/lib/glide/glide-bin $out/bin/glide \
        --set LD_LIBRARY_PATH "${libraryPath}"
    '';

    meta = with lib; {
      description = "Glide Browser";
      homepage = "https://glide-browser.app/";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  }
