{ stdenv, fetchurl, autoreconfHook, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  name = "steamos-modeswitch-inhibitor-${version}";
  version = "1.35";

  src = fetchurl {
    url = "http://repo.steamstatic.com/steamos/pool/main/s/steamos-modeswitch-inhibitor/steamos-modeswitch-inhibitor_1.10.tar.xz";
    sha256 = "1lskfb4l87s3naz2gmc22q0xzvlhblywf5z8lsiqnkrrxnpbbwj7";
  };
  
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = with xorg; [ libXxf86vm libX11 libXrender libXrandr ];

  meta = with stdenv.lib; {
    description = "The official steamos modeswitch ihibitor";
    license = licenses.gpl;
    maintainers = with maintainers; [ FlorianFranzen ];
    platforms = platforms.linux;
  };
}
