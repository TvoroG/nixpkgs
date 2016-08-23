{ lib, stdenv, fetchurl, makeWrapper, nwjs, zip, alsaLib, gconf
, gtk, nss, libnotify }:

let
  arch = if stdenv.system == "x86_64-linux" then "64"
    else if stdenv.system == "i686-linux"   then "32"
    else throw "Unsupported system ${stdenv.system}";

in stdenv.mkDerivation rec {
  name = "popcorntime-${version}";
  version = "0.3.9";
  build = "2";

  src = fetchurl {
    url = "https://get.popcorntime.sh/build/Popcorn-Time-${version}-Linux-${arch}.tar.xz";
    sha256 =
      if arch == "64"
      then "5655111b7f5883ce7a620a8fb0b9f7fb7563a46516697aac5ad2b28b8b5e49df"
      else "0c8a84e853946c70b4986d8044ec869f995b8001b48cd5bd3ef0ed61e8848335";
  };

  dontPatchELF = true;
  sourceRoot = ".";
  buildInputs  = [ zip makeWrapper alsaLib gconf gtk nss libnotify ];

  buildPhase = ''
    cd linux${arch}
    rm Popcorn-Time
    cat ${nwjs}/bin/nw nw.pak > Popcorn-Time
    chmod 555 Popcorn-Time
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    makeWrapper $out/Popcorn-Time $out/bin/popcorntime
  '';

  meta = with stdenv.lib; {
    homepage = https://popcorntime.sh/;
    description = "An application that streams movies and TV shows from torrents";
    license = stdenv.lib.licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden rnhmjoj ];
  };
}
