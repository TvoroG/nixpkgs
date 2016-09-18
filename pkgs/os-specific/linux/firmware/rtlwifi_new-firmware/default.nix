{ stdenv, linuxPackages }:
with stdenv.lib;
stdenv.mkDerivation {
  name = "rtlwifi_new-firmware-git-${linuxPackages.rtlwifi_new.version}";
  inherit (linuxPackages.rtlwifi_new) src;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out/lib/firmware"
    cp -rf firmware/rtlwifi/ "$out/lib/firmware"
  '';

  meta = with stdenv.lib; {
    description = "Firmware for the newest Realtek rtlwifi codes";
    homepage = https://github.com/lwfinger/rtlwifi_new;
    license = licenses.unfreeRedistributableFirmware;
    platforms = with platforms; linux;
  };
}
