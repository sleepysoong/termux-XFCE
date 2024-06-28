#!/data/data/com.termux/files/usr/bin/bash
SCRIPT_VERSION="1.0"

export GREEN='\033[0;32m'
export TURQ='\033[0;36m'
export URED='\033[4;31m'
export UYELLOW='\033[4;33m'
export WHITE='\033[0;37m'
export SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export PROOT_ROOT=$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root

export TERMUX_WIDGET_LINK='https://github.com/termux/termux-widget/releases/download/v0.13.0/termux-widget_v0.13.0+github-debug.apk'

# termux 셋업
termux_base_setup()
{
    set -e
    sleep 1
    echo -e "${GREEN}termux 업데이트 && 업그레이드.${WHITE}"
	pkg update -y && pkg upgrade -y
    sleep 1
    echo -e "${GREEN}termux 외부앱 허용, 진동-> 무음으로 변경.${WHITE}"
    # 기본세팅 외부앱 사용가능
    sleep 1
    sed -i 's/# allow-external-apps = true/allow-external-apps = true/g' /data/data/com.termux/files/home/.termux/termux.properties
    # 진동:무음
    sleep 1
    sed -i 's/# bell-character = ignore/bell-character = ignore/g' /data/data/com.termux/files/home/.termux/termux.properties


    sleep 1
	echo -e "${GREEN}unzip설치.${WHITE}"
	pkg install -y unzip 2>/dev/null

    sleep 1
	echo -e "${GREEN}alias 추가.${WHITE}"
    echo "
alias ll='ls -alhF'
alias shutdown='kill -9 -1'" >> $PREFIX/etc/bash.bashrc

    source ~/.bashrc

    echo -e "${GREEN}tur-repo추가${WHITE}"
    pkg install -y tur-repo
    if ! grep -q "tur-multilib tur-hacking" ~/../usr/etc/apt/sources.list.d/tur.list; then
        sed -i 's/$/ tur-multilib tur-hacking/' ~/../usr/etc/apt/sources.list.d/tur.list
    fi

    sleep 1
    echo -e "${GREEN}x11-repo, root-repo 설치${WHITE}"
    pkg install x11-repo -y 2>/dev/null
	pkg install root-repo -y 2>/dev/null
	pkg update -y

    sleep 1
    echo -e "${GREEN}turmux-x11-nightly 설치 ${WHITE}"
    pkg install -y termux-x11-nightly 2>/dev/null
    
    sleep 1
    echo -e "${GREEN}xorg-server-xvfb 설치${WHITE}"
    pkg install -y xorg-server-xvfb 2>/dev/null

    echo -e "${GREEN}vulkan-tools 설치${WHITE}"
	pkg install -y vulkan-tools 2>/dev/null
    sleep 1
	pkg install -y vulkan-loader-android 2>/dev/null

    sleep 1
    echo -e "${GREEN}mesa-zink, mesa-vulkan-icd-freedreno-dri3 설치${WHITE}"
	pkg install -y mesa-zink mesa-vulkan-icd-freedreno-dri3 2>/dev/null

    sleep 1
    echo -e "${GREEN}turmux-x11-nightly 설치 ${WHITE}"
    pkg install -y termux-x11-nightly 2>/dev/null
    
    sleep 1
    echo -e "${GREEN}한글 설치 ${WHITE}"
    pkg install fcitx5-hangul libhangul libhangul-static fcitx5-configtool -y 2>/dev/null

    sleep 1
    echo -e "${GREEN}which 설치${WHITE}"
    pkg install -y which 2>/dev/null
    sleep 1
    echo -e "${GREEN}Termux-widget 설치.${WHITE}"
    wget $TERMUX_WIDGET_LINK -O termux-widget_v0.13.0+github-debug.apk
	termux-open termux-widget_v0.13.0+github-debug.apk

	echo -e "${GREEN}termux x11, widget 설치파일 삭제.${WHITE}"
    rm termux-widget*.apk

}

termux_etc_install(){
    sleep 1
    echo -e "${GREEN}firefox 설치 ${WHITE}"
    pkg install -y firefox  2>/dev/null

    sleep 1
    echo -e "${GREEN}chromium 설치 ${WHITE}"
    pkg install -y chromium  2>/dev/null
}

termux_hangover_wine_install()
{
    set -e
    sleep 1
    echo -e "${GREEN}tur-multilib, tur-hacking 저장소 추가${WHITE}"

    if ! grep -q "tur-multilib tur-hacking" ~/../usr/etc/apt/sources.list.d/tur.list; then
        sed -i 's/$/ tur-multilib tur-hacking/' ~/../usr/etc/apt/sources.list.d/tur.list
    fi
    sleep 1

    echo -e "${GREEN}의존프로그램 설치${WHITE}"
	pkg install -y cabextract clang 7zip freetype gnutls libandroid-shmem-static libx11 xorgproto mesa-demos libdrm libpixman libxfixes libjpeg-turbo xtrans libxxf86vm xorg-xrandr xorg-font-util xorg-util-macros libxfont2 libxkbfile libpciaccess xcb-util-renderutil xcb-util-image xcb-util-keysyms xcb-util-wm xorg-xkbcomp xkeyboard-config libxdamage libxinerama libxshmfence

    sleep 1
    echo -e "${GREEN}hangover-wine 설치${WHITE}"
    pkg install -y hangover-wine

    sleep 1
    echo -e "${GREEN}winetricks 설치${WHITE}"
    pkg install -y winetricks


}


termux_base_setup
termux_etc_install
termux_hangover_wine_install
