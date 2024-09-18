{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-keys,
  eth-utils,
  pycryptodome,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eth-keyfile";
  version = "0.8.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keyfile";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-HufsN3aXdQErcQmnG2PZnEm5joqpy4f8IWNm3VrzJSY=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    eth-keys
    eth-utils
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "eth_keyfile" ];

  meta = with lib; {
    description = "Tools for handling the encrypted keyfile format used to store private keys";
    homepage = "https://github.com/ethereum/eth-keyfile";
    license = licenses.mit;
    maintainers = [ ];
  };
}
