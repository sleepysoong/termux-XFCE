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
    echo -e "${GREEN}사운드 설정.${WHITE}"

    sleep 1
    echo -e "${GREEN} alias 설정.${WHITE}"
    echo "
alias ll='ls -alhF'
alias zink='GALLIUM_DRIVER=zink MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform $@ '
#alias zink='GALLIUM_DRIVER=zink MESA_GL_VERSION_OVERRIDE=4.6COMPAT TU_DEBUG=noconform $@ '
alias shutdown='kill -9 -1'" >> $PREFIX/etc/bash.bashrc

    source $PREFIX/etc/bash.bashrc

    sleep 1
	echo -e "${GREEN}unzip설치.${WHITE}"
	pkg install -y unzip

    echo -e "${GREEN}tur-repo추가${WHITE}"
    pkg install -y tur-repo
    if ! grep -q "tur-multilib tur-hacking" ~/../usr/etc/apt/sources.list.d/tur.list; then
        sed -i 's/$/ tur-multilib tur-hacking/' ~/../usr/etc/apt/sources.list.d/tur.list
    fi

    sleep 1
    echo -e "${GREEN}x11-repo, root-repo 설치${WHITE}"
    pkg install x11-repo -y
	pkg install root-repo -y
	pkg update -y && pkg upgrade -y

    sleep 1
	echo -e "${GREEN}eza 설치.${WHITE}"
	pkg install -y eza

    sleep 1
	echo -e "${GREEN}neofetch설치.${WHITE}"
	pkg install -y neofetch

    sleep 1
	echo -e "${GREEN} bat 설치.${WHITE}"
	pkg install -y  bat
    
    sleep 1
	echo -e "${GREEN}pavucontrol-qt 설치.${WHITE}"
	pkg install -y pavucontrol-qt

    sleep 1
	echo -e "${GREEN}jq 설치.${WHITE}"
	pkg install -y jq
 
    sleep 1
	echo -e "${GREEN}wmctrl 설치.${WHITE}"
	pkg install -y wmctrl

    sleep 1
	echo -e "${GREEN}netcat-openbsd 설치.${WHITE}"
	pkg install -y netcat-openbsd
  
    sleep 1
    echo -e "${GREEN}turmux-x11-nightly 설치 ${WHITE}"
    pkg install -y termux-x11-nightly
    
    sleep 1
    echo -e "${GREEN}xorg-server-xvfb 설치${WHITE}"
    pkg install -y xorg-server-xvfb

    echo -e "${GREEN}vulkan-tools 설치${WHITE}"
	pkg install -y vulkan-tools
    sleep 1
	pkg install -y vulkan-loader-android

    sleep 1
    echo -e "${GREEN}mesa-zink, mesa-vulkan-icd-freedreno-dri3 설치${WHITE}"
	pkg install -y mesa-zink mesa-vulkan-icd-freedreno-dri3

    sleep 1
    echo -e "${GREEN}turmux-x11-nightly 설치 ${WHITE}"
    pkg install -y termux-x11-nightly
    
    sleep 1
    echo -e "${GREEN}한글 설치 ${WHITE}"
    pkg install fcitx5-hangul libhangul libhangul-static fcitx5-configtool -y

    sleep 1
    echo -e "${GREEN}which 설치${WHITE}"
    pkg install -y which

    sleep 1
    echo -e "${GREEN}Termux-widget 설치.${WHITE}"
    wget $TERMUX_WIDGET_LINK -O termux-widget_v0.13.0+github-debug.apk
	termux-open termux-widget_v0.13.0+github-debug.apk

	echo -e "${GREEN}termux widget 설치파일 삭제.${WHITE}"
    rm termux-widget*.apk

    echo -e "${GREEN}shortcuts 생성.${WHITE}"
    mkdir ~/.shortcuts
    
echo -e '#!/bin/sh
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android virgl_test_server
termux-wake-lock; termux-toast "Starting X11"

pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

XDG_RUNTIME_DIR=${TMPDIR} termux-x11 :1.0 &
sleep 1

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
sleep 1

MESA_NO_ERROR=1 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 virgl_test_server_android --angle-gl &
env DISPLAY=:1.0 dbus-launch --exit-with-session xfce4-session &' > ~/.shortcuts/startXFCE

    chmod +x ~/.shortcuts/startXFCE

    sleep 1
    echo "$HOME/.shortcuts/startXFCE" > $PREFIX/bin/startXFCE
    chmod +x $PREFIX/bin/startXFCE
}

termux_etc_install(){
    sleep 1
    echo -e "${GREEN}firefox 설치 ${WHITE}"
    pkg install -y firefox 

    sleep 1
    echo -e "${GREEN}chromium 설치 ${WHITE}"
    pkg install -y chromium 

    sleep 1
    echo -e "${GREEN}gimp 설치 ${WHITE}"
    pkg install -y gimp 
}

termux_hangover_wine_install()
{
    set -e
    sleep 1
    echo -e "${GREEN}tur-multilib, tur-hacking 저장소 추가${WHITE}"

    if !grep -q "tur-multilib tur-hacking" ~/../usr/etc/apt/sources.list.d/tur.list; then
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
