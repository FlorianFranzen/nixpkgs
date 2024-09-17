{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  eth-hash,
  eth-typing,
  eth-utils,
  hypothesis,
  parsimonious,
  pytestCheckHook,
  pytest-xdist,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-abi";
  version = "5.1.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-abi";
    rev = "v${version}";
    hash = "sha256-D3aGMx2oZFttwQ90ouwQbbRelCb2bvyQgvamKweX9Nw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    eth-typing
    eth-utils
    parsimonious
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # boolean list representation changed
    "test_get_abi_strategy_returns_certain_strategies_for_known_type_strings"
  ];

  pythonImportsCheck = [ "eth_abi" ];

  meta = with lib; {
    description = "Ethereum ABI utilities";
    homepage = "https://github.com/ethereum/eth-abi";
    license = licenses.mit;
    maintainers = [ ];
  };
}
