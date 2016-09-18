{ stdenv, fetchFromGitHub, kernel }:
let modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi";
in with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtlwifi_new-git-${version}";
  version = "2016-09-12";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtlwifi_new";
    rev = "7a1b37d2121e8ab1457f002b2729fc23e6ff3e10";
    sha256 = "0z8grf0fak2ryxwzapp9di77c4bghzkv8lffv76idkcnxgq6sclv";
  };

  hardeningDisable = [ "pic" "format" ];

  makeFlags = concatStringsSep " " [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODDESTDIR=$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtlwifi"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}/btcoexist
    mkdir -p ${modDestDir}/rtl8188ee
    mkdir -p ${modDestDir}/rtl8192c
    mkdir -p ${modDestDir}/rtl8192ce
    mkdir -p ${modDestDir}/rtl8192cu
    mkdir -p ${modDestDir}/rtl8192de
    mkdir -p ${modDestDir}/rtl8192ee
    mkdir -p ${modDestDir}/rtl8192se
    mkdir -p ${modDestDir}/rtl8723ae
    mkdir -p ${modDestDir}/rtl8723be
    mkdir -p ${modDestDir}/rtl8821ae
    cp rtl_pci.ko ${modDestDir}
    cp rtl_usb.ko ${modDestDir}
    cp rtlwifi.ko ${modDestDir}
    cp ./btcoexist/btcoexist.ko ${modDestDir}/btcoexist
    cp ./rtl8188ee/rtl8188ee.ko ${modDestDir}/rtl8188ee
    cp ./rtl8192c/rtl8192c-common.ko ${modDestDir}/rtl8192c
    cp ./rtl8192ce/rtl8192ce.ko ${modDestDir}/rtl8192ce
    cp ./rtl8192cu/rtl8192cu.ko ${modDestDir}/rtl8192cu
    cp ./rtl8192de/rtl8192de.ko ${modDestDir}/rtl8192de
    cp ./rtl8192ee/rtl8192ee.ko ${modDestDir}/rtl8192ee
    cp ./rtl8192se/rtl8192se.ko ${modDestDir}/rtl8192se
    cp ./rtl8723ae/rtl8723ae.ko ${modDestDir}/rtl8723ae
    cp ./rtl8723be/rtl8723be.ko ${modDestDir}/rtl8723be
    cp ./rtl8821ae/rtl8821ae.ko ${modDestDir}/rtl8821ae

    xz -f ${modDestDir}/*.ko
    xz -f ${modDestDir}/btcoexist/*.ko
    xz -f ${modDestDir}/rtl8*/*.ko
  '';

  meta = {
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtlwifi_new";
    platforms = with platforms; linux;
    priority = -1;
  };
}
