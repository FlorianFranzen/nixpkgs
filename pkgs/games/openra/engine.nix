/*  The package defintion for an OpenRA engine.
    It shares code with `mod.nix` by what is defined in `common.nix`.
    Similar to `mod.nix` it is a generic package definition,
    in order to make it easy to define multiple variants of the OpenRA engine.
    For each mod provided by the engine, a wrapper script is created,
    matching the naming convention used by `mod.nix`.
    This package could be seen as providing a set of in-tree mods,
    while the `mod.nix` pacakges provide a single out-of-tree mod.
*/
{ lib, stdenv
, writeText
, fetchurl
, packageAttrs
, patchEngine
, wrapLaunchGame
, engine
}:

with lib;

let
  deps = map (package: package.src)
    (import ./deps.nix { inherit fetchurl; });

  nuget-config = writeText "NuGet.Config" ''
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <packageSources>
        <clear />
      </packageSources>
    </configuration>
  '';

in stdenv.mkDerivation (recursiveUpdate packageAttrs rec {
  name = "${pname}-${version}";
  pname = "openra";
  version = "0.0.0-${engine.version}";

  src = engine.src;

  #postPatch = patchEngine "." version;

  configurePhase = ''
    runHook preConfigure

    make version VERSION=${engine.name}-${engine.version}

    cp ${nuget-config} NuGet.Config && chmod 660 NuGet.Config
    nuget sources Add -Name nixos -Source $(pwd)/nixos

    for package in ${toString deps}; do
      nuget add $package -Source nixos
    done

    runHook postConfigure
  '';

  HOME = "/tmp/fake-home";

  buildFlags = [ "RUNTIME=mono" ];

  checkTarget = "test";

  installTargets = [
    "install"
    "install-linux-shortcuts"
  ];

  postInstall = ''
    ${wrapLaunchGame ""}

    ${concatStrings (map (mod: ''
      makeWrapper $out/bin/openra $out/bin/openra-${mod} --add-flags Game.Mod=${mod}
    '') engine.mods)}
  '';

  meta = {
    inherit (engine) description homepage;
  };
})
