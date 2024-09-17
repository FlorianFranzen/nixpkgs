{
  lib,
  fetchFromGitHub,
  clang,
  buildPythonPackage,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ckzg";
  version = "2.0.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "c-kzg-4844";
    rev = "v${version}";
    hash = "sha256-mpDVuAghIPplopr/mij9LSEjbVEwmZw3Agyp2DNBbNI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    clang
    setuptools
  ];

  nativeCheckInputs = [ pyyaml ];
  checkPhase = "cd bindings/python && python tests.py";

  pythonImportsCheck = [ "ckzg" ];

  meta = {
    description = "A minimal implementation of the Polynomial Commitments API for EIP-4844 and EIP-7594.";
    homepage = "https://github.com/ethereum/c-kzg-4844";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
