{ lib, stdenv
, fetchurl
, autoPatchelfHook
, appimageTools
, makeWrapper
, electron_11
, zlib
}:

let
  electron = electron_11;
in
stdenv.mkDerivation rec {
  pname = "radicle-upstream";
  version = "0.1.9";

  src = fetchurl {
    url = "https://releases.radicle.xyz/radicle-upstream-${version}.AppImage";
    sha256 = "0zrl01qz40dr3xizmc93c28fchdg7wrcw6fc87xs7n29cknvgv49";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ zlib ];
  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/radicle-upstream.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar
  '';

  meta = with lib; {
    description = "A desktop client for Radicle";
    homepage = "https://radicle.xyz";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
