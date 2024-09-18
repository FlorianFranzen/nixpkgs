{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,
  pythonAtLeast,
  pythonOlder,
  pycryptodome,
  pytest,
  pytest-xdist,
  safe-pysha3,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.7.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-hash";
    rev = "v${version}";
    hash = "sha256-tFKq+WN8Z1BIAOIfaRtVt4+pnZ99FwHO8/pycmQx5Gg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs =
    [
      pytest
      pytest-xdist
    ]
    ++ passthru.optional-dependencies.pycryptodome
    # safe-pysha3 is not available on pypy
    ++ lib.optional (!isPyPy) passthru.optional-dependencies.pysha3;

  # Backends need to be tested separatly and can not use hook
  checkPhase =
    ''
      pytest tests/core tests/backends/pycryptodome
    ''
    + lib.optionalString (!isPyPy) ''
      pytest tests/backends/pysha3
    '';

  passthru.optional-dependencies = {
    pycryptodome = [ pycryptodome ];
    pysha3 = [ safe-pysha3 ];
  };

  meta = with lib; {
    description = "Ethereum hashing function keccak256";
    homepage = "https://github.com/ethereum/eth-hash";
    license = licenses.mit;
    maintainers = [ ];
  };
}
