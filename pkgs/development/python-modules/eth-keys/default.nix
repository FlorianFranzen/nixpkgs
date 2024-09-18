{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asn1tools,
  coincurve,
  eth-hash,
  eth-typing,
  eth-utils,
  factory-boy,
  hypothesis,
  isPyPy,
  pyasn1,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eth-keys";
  version = "0.5.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keys";
    rev = "v${version}";
    hash = "sha256-KRIN3Yxu0N+XL7zpkNJHaIoSB6YODus7LIQEgX9U0bI=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    eth-typing
    eth-utils
  ];

  nativeCheckInputs =
    [
      asn1tools
      factory-boy
      hypothesis
      pyasn1
      pytestCheckHook
    ]
    ++ passthru.optional-dependencies.coincurve
    ++ lib.optional (!isPyPy) eth-hash.optional-dependencies.pysha3
    ++ lib.optional isPyPy eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_keys" ];

  passthru.optional-dependencies = {
    coincurve = [ coincurve ];
  };

  meta = with lib; {
    description = "Common API for Ethereum key operations";
    homepage = "https://github.com/ethereum/eth-keys";
    license = licenses.mit;
    maintainers = [ ];
  };
}
