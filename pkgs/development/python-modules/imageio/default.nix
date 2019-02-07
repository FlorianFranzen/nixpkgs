{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
, psutil
, pytest
, numpy
, isPy3k
, futures
, enum34
}:

buildPythonPackage rec {
  pname = "imageio";
  version = "2.5.0";

  src = fetchPypi {
    sha256 = "1bdcrr5190jvk0msw2lswj4pbdhrcggjpj8m6q2a2mrxzjnmmrj2";
    inherit pname version;
  };

  checkInputs = [ pytest psutil ];
  propagatedBuildInputs = [ numpy pillow ] ++ stdenv.lib.optionals (!isPy3k) [
    futures
    enum34
  ];

  checkPhase = ''
    export IMAGEIO_USERDIR="$TMP"
    export IMAGEIO_NO_INTERNET="true"
    export HOME="$(mktemp -d)"
    py.test
  '';

  # For some reason, importing imageio also imports xml on Nix, see
  # https://github.com/imageio/imageio/issues/395
  postPatch = ''
    substituteInPlace tests/test_meta.py --replace '"urllib",' "\"urllib\",\"xml\""
  '';

  meta = with stdenv.lib; {
    description = "Library for reading and writing a wide range of image, video, scientific, and volumetric data formats";
    homepage = http://imageio.github.io/;
    license = licenses.bsd2;
  };

}
