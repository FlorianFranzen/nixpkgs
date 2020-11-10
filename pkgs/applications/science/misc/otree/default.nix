{ lib, python3Packages }:

with python3Packages;

let
  django-vanilla-views = buildPythonPackage rec {
    pname = "django-vanilla-views";
    version = "2.0.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "c65717fc940340d668b3f47d80bbe8565d63de9b1c089bb5d9482dbb2410a508";
    };

    # TODO: Fix tests
    buildInputs = [ django six ];

    doCheck = false;
  };

  honcho = buildPythonPackage rec {
    pname = "honcho";
    version = "1.0.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "c189402ad2e337777283c6a12d0f4f61dc6dd20c254c9a3a4af5087fc66cea6e";
    };

    # TODO: Fix tests
    doCheck = false;
  };

in buildPythonApplication rec {
  pname = "otree";
  version = "3.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1228a678140cc46dca5b6bc54597e991cea1fd9b293bfe2a858708bcc40d1436";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  propagatedBuildInputs = [
    asgiref
    asn1crypto
    automat
    cffi
    channels
    colorama
    daphne
    django
    django-vanilla-views
    dj-database-url
    honcho
    huey
    hyperlink
    idna
    pyhamcrest
    pyopenssl
    redis
    sentry-sdk
    service-identity
    termcolor
    twisted
    urllib3
    whitenoise
    XlsxWriter
  ];

  preFixup = ''
    makeWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
  '';

  # TODO: Fix tests
  doCheck = false;

  meta = with lib; {
    description = "a toolset to create and administer web-based social science experiments";
    homepage = "https://www.otree.org";
    license = licenses.mit;
  };
}

