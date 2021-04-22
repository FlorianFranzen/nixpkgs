{ buildOpenRAEngine, fetchFromGitHub, extraPostFetch }:

let
  buildUpstreamOpenRAEngine = { version, rev, sha256 }: name: (buildOpenRAEngine {
    inherit version;
    description = "Open-source re-implementation of Westwood Studios' 2D Command and Conquer games";
    homepage = "https://www.openra.net/";
    mods = [ "cnc" "d2k" "ra" "ts" ];
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "OpenRA" ;
      inherit rev sha256 extraPostFetch;
    };
  } name).overrideAttrs (origAttrs: {
    postInstall = ''
      ${origAttrs.postInstall}
      cp -r mods/ts $out/lib/openra/mods/
      cp mods/ts/icon.png $(mkdirp $out/share/pixmaps)/openra-ts.png
      ( cd $out/share/applications; sed -e 's/Dawn/Sun/g' -e 's/cnc/ts/g' openra-cnc.desktop > openra-ts.desktop )
    '';
  });

in {
  release = name: (buildUpstreamOpenRAEngine rec {
    version = "20210321";
    rev = "${name}-${version}";
    sha256 = "11hdpfvs4qrlq1g4sr4ack18a7ky869rf7hbngqdsqzp1cyb0j9x";
  } name);

  playtest = name: (buildUpstreamOpenRAEngine rec {
    version = "20210131";
    rev = "${name}-${version}";
    sha256 = "1vqvfk2p2lpk3m0d3rpvj33i8cmk3mfc7w4cn4llqd9zp4kk9pya";
  } name);

  bleed = buildUpstreamOpenRAEngine {
    version = "f1d66a4";
    rev = "f1d66a4c70599efede653421b57baa3d3c1a0183";
    sha256 = "0f1fpf37ms8d7fhlh3rjzsxsk9w33iyi3phs2i7g561292d5rk3l";
  };
}
