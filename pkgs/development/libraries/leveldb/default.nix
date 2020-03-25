{ stdenv, fetchFromGitHub, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "leveldb";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "${version}";
    sha256 = "0qrnhiyq7r4wa1a4wi82zgns35smj94mcjsc7kfs1k6ia9ys79z7";
  };

  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames ];

  postInstall = ''
    mkdir $out/bin
    cp leveldbutil $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/google/leveldb;
    description = "Fast and lightweight key/value database library by Google";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
