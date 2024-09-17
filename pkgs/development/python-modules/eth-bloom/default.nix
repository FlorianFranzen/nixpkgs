{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  eth-hash,
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-bloom";
  version = "3.0.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-bloom";
    rev = "v${version}";
    hash = "sha256-PmO4HFHAwoj3LQRVWQGndYSGwQ54c+/OkJqYPYtuVNk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ eth-hash ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_bloom" ];

  meta = with lib; {
    description = "An implementation of the Ethereum bloom filter.";
    homepage = "https://github.com/ethereum/eth-bloom";
    license = licenses.mit;
    maintainers = [ ];
  };
}
