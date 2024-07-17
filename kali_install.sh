#!/data/data/com.termux/files/usr/bin/bash
export GREEN='\033[0;32m'
export TURQ='\033[0;36m'
export URED='\033[4;31m'
export UYELLOW='\033[4;33m'
export WHITE='\033[0;37m'

get_device_arch=$(getprop ro.product.cpu.abi)
get_device_arch_short=$(getprop ro.product.cpu.abi | cut -d '-' -f1)
install_rootfs="$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack"
base_url="https://kali.download/nethunter-images/current/rootfs"
sha256_url="$base_url/SHA256SUMS"

rootfs="kalifs-$get_device_arch_short-minimal.tar.xz"
    
SHA256=$(curl -s "$sha256_url" | grep "$rootfs" | awk '{print $1}')

if [[ -z "$SHA256" ]]; then
    echo -e "${GREEN}SHA256 checksum이 일치하지 않습니다 스크립트를 종료합니다.${WHITE}"
    exit 1
fi

echo -e "
# This is a default distribution plug-in.
# Do not modify this file as your changes will be overwritten on next update.
# If you want customize installation, please make a copy.
# Kali nethunter ${get_device_arch}
DISTRO_NAME=\"kali-linux (${get_device_arch_short})\"
DISTRO_COMMENT=\"Kali-linux 설치파일입니다.\"
TARBALL_URL['aarch64']=\"$base_url/$rootfs\"
TARBALL_SHA256['aarch64']=\"${SHA256}\""> $PREFIX/etc/proot-distro/BackTrack.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN} kali-linux설치 파일이 작성되었습니다. ${WHITE}"
fi

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

tusername="$1"
username="$2"

pkgs_proot=('sudo' 'wget' 'jq' 'flameshot' 'conky-all' 'zenity')

#Install BackTrack proot
pd install BackTrack
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 apt update
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 apt upgrade -y
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 apt install "${pkgs_proot[@]}" -y -o Dpkg::Options::="--force-confold"

#Create user
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 groupadd storage
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 groupadd wheel
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 useradd -m -g users -G wheel,audio,video,storage -s /bin/bash "$username"

#Add user to sudoers
chmod u+rw $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/etc/sudoers
echo "$username ALL=(ALL) NOPASSWD:ALL" | tee -a $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/etc/sudoers > /dev/null
chmod u-w  $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/etc/sudoers


#Set proot DISPLAY
echo "export DISPLAY=:1.0" >> $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.bashrc

#Set Sound
echo "LD_PRELOAD=/system/lib64/libskcodec.so" >> $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.bashrc

cat <<'EOF' > $PREFIX/bin/krun
#!/data/data/com.termux/files/usr/bin/bash
varname=$(basename $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/*)
pd login BackTrack --user $username --shared-tmp -- env DISPLAY=:1.0 $@

EOF
chmod +x $PREFIX/bin/krun

#Set proot aliases
echo "
alias hud='GALLIUM_HUD=fps '
alias ls='eza -lF --icons'
alias ll='ls -alhF'
alias shutdown='kill -9 -1'
alias cat='bat '
alias start='echo please run from termux, not BackTrack proot.'
" >> $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.bashrc

#Set Don't show kali-text
touch $install_rootfs/root/.hushlogin
touch $install_rootfs/home/$username/.hushlogin

#Set proot timezone
timezone=$(getprop persist.sys.timezone)
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 rm /etc/localtime
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 cp /usr/share/zoneinfo/$timezone /etc/localtime

#set aliase
echo "
alias kali='proot-distro login BackTrack --user $username --shared-tmp'
" >> $PREFIX/etc/bash.bashrc

#Setup Fancybash Proot
cp .fancybash.sh $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username
echo "source ~/.fancybash.sh" >> $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.bashrc
sed -i "326s/$tusername/$username/" $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.fancybash.sh
sed -i '327s/termux/kali/' $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.fancybash.sh

wget https://github.com/yanghoeg/Termux_XFCE/raw/main/conky.tar.gz
tar -xvzf conky.tar.gz
rm -f conky.tar.gz

if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.config" ]; then
  mkdir -p "$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.config"
fi
mv .config/conky/ $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.config
mv .config/neofetch/ $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.config
file="$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.config/neofetch/config.conf"
sed -i 's/ascii_distro="Ubuntu"/ascii_distro="Kali-linux"/' $file

#Set theming from xfce to proot
cp -r $PREFIX/share/icons/dist-dark $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/usr/share/icons/dist-dark

cat <<'EOF' > $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.Xresources
Xcursor.theme: dist-dark
EOF

if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.fonts" ]; then
    mkdir -p "$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.fonts/"
fi

cp .fonts/NotoColorEmoji-Regular.ttf $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/home/$username/.fonts/ 

#Setup Hardware Acceleration
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/yanghoeg/Termux_XFCE/raw/main/mesa-vulkan-kgsl_24.1.0-devel-20240120_arm64.deb
pd login BackTrack --shared-tmp -- env DISPLAY=:1.0 sudo apt install -y ./mesa-vulkan-kgsl_24.1.0-devel-20240120_arm64.deb

wget https://github.com/yanghoeg/Termux_XFCE/raw/main/kali_install_etc_app.sh
chmod +x ./kali_install_etc_app.sh
cp ./kali_install_etc_app.sh $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/root/kali_install_etc_app.sh
chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/root/kali_install_etc_app.sh
proot-distro login BackTrack --user root --shared-tmp --no-sysvipc -- bash -c "./kali_install_etc_app.sh $username"
sleep 1
rm -f $PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack/root/kali_install_etc_app.sh