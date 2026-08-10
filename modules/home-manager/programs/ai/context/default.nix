{
  lib,
  ...
}:
let
  contextDir = ./.;
  contextFiles = lib.filter (f: lib.hasSuffix ".md" f) (builtins.attrNames (builtins.readDir contextDir));
in
  lib.concatMapStringsSep "\n\n" (filename: builtins.readFile "${contextDir}/${filename}") (
    lib.sort lib.lessThan contextFiles
  )
