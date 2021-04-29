{ lib, stdenv, kernel, fetchFromGitHub }:

let
  version = "0.9.1";
in
  stdenv.mkDerivation {
    pname = "lkrg";
    version = "${version}-${kernel.version}";

    src = fetchFromGitHub {
      owner = "openwall";
      repo = "lkrg";
      rev = "v${version}";
      sha256 = "1jicmxkmqbaxmm64nknvqzbb2w4bhgyvgiqnmnd7h17sbf9sw4lc";
    };

    patches = [ ./KERNEL.patch ];

    KERNEL = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

    nativeBuildInputs = kernel.moduleBuildDependencies;

    installPhase = ''
      INSTALL_MOD_PATH=$out make -C $KERNEL M=/build/source modules_install 
    '';

    meta = with lib; {
      description = "Linux Kernel Runtime Guard";
      homepage = "https://www.openwall.com/lkrg";
      license = licenses.gpl2;
      platforms = platforms.linux;
      #broken = !(kernel.config.isYes "KALLSYMS_ALL");
      maintainers = with maintainers; [ FlorianFranzen ];
    };
  }
