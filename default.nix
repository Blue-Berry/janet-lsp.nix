{ lib
, stdenvNoCC
, fetchurl
, janet
, makeWrapper
, version ? "0.0.0"
}:

stdenvNoCC.mkDerivation rec {
  pname = "janet-lsp";
  inherit version;

  src = fetchurl {
    url = "https://github.com/CFiggers/janet-lsp/releases/download/v${version}/janet-lsp.jimage";
    sha256 = "sha256-UZXeWBMP9ars972VIVqnuFxge4RU+4l9nniQCAQldpc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;

  installPhase = ''
    install -Dm444 "$src" "$out/share/${pname}/janet-lsp.jimage"
    makeWrapper ${janet}/bin/janet "$out/bin/janet-lsp" \
      --add-flags "-i $out/share/${pname}/janet-lsp.jimage"
  '';

  meta = with lib; {
    description = "Janet LSP packaged as a runnable jimage";
    homepage = "https://github.com/CFiggers/janet-lsp";
    platforms = platforms.unix;
    mainProgram = "janet-lsp";
  };
}
