{ stdenv, fetchurl, autoreconfHook, pkgconfig, makeWrapper
, coreutils, gnugrep, xorg, libGL, SDL, SDL_image, libudev }:

stdenv.mkDerivation rec {
  name = "steamos-compositor-${version}";
  version = "1.35";

  src = fetchurl {
    url = "http://repo.steamstatic.com/steamos/pool/main/s/steamos-compositor/steamos-compositor_1.35.tar.xz";
    sha256 = "09hmzmwkdfj78lihag4hsvv9dsik8ic2prdqfq6xjn8z6ry0l9px";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig makeWrapper ];
  buildInputs = with xorg; [ libGL SDL SDL_image libudev
    libXxf86vm libX11 libXrender libXcomposite libXext libXdamage
  ];

  preInstall = "mkdir $out && mv usr/bin usr/share $out";

  postInstall = ''
    wrapProgram $out/bin/steamos/set_hd_mode.sh \
      --prefix PATH : "${stdenv.lib.makeBinPath [ coreutils gnugrep xorg.xrandr ]}"
  '';

  meta = with stdenv.lib; {
    description = "The official steamos compositor";
    license = licenses.gpl;
    maintainers = with maintainers; [ FlorianFranzen ];
    platforms = platforms.linux;
  };
}
