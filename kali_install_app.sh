#!/data/data/com.termux/files/usr/bin/bash
export GREEN='\033[0;32m'
export TURQ='\033[0;36m'
export URED='\033[4;31m'
export UYELLOW='\033[4;33m'
export WHITE='\033[0;37m'

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

finish() {
  local ret=$?
  if [ ${ret} -ne 0 ] && [ ${ret} -ne 130 ]; then
    echo
    echo "ERROR: XFCE on Termux 설치에 실패하였습니다."
    echo "위 error message를 참고하세요"
  fi
}

trap finish EXIT

varname="$1"

proot-distro login BackTrack --shared-tmp -- env DISPLAY=:1.0 apt update
proot-distro login BackTrack --shared-tmp -- env DISPLAY=:1.0 sudo apt install kali-linux-core kali-defaults kali-menu kali-linux-large -y
#cp $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/usr/share/applications/kali* $PREFIX/share/applications
#sed -i "s/^Exec=\(.*\)$/Exec=proot-distro login BackTrack --user $varname --shared-tmp -- env DISPLAY=:1.0 \1/"   $PREFIX/share/applications/kali*
