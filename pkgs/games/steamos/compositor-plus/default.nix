{ stdenv, steamos-compositor, fetchFromGitHub }:

steamos-compositor.overrideAttrs (attrs: rec {
  name = "steamos-compositor-plus-${version}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "alkazar";
    repo = "steamos-compositor";
    rev = version;
    sha256 = "0w7qcx6lcb7lh56v0bjxlvpf2yq26sq9f05ij3gi3i9x9vbpsg4x";
  };

  meta = with stdenv.lib; {
    description = "A fork of the steamos compositor which fixes some games";
    homepage = https://github.com/alkazar/steamos-compositor;
    license = licenses.gpl;
    maintainers = with maintainers; [ FlorianFranzen ];
    platforms = platforms.linux;
  };
})
