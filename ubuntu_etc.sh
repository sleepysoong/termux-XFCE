#!/bin/bash
export GREEN='\033[0;32m'
export URED='\033[4;31m'
export UYELLOW='\033[4;33m'
export WHITE='\033[0;37m' 

echo -e "${GREEN}Ubuntu proot 관련프로그램을 설치합니다(XFCE4, GPU가속기 등을 설치합니다)."

install_base_packages(){
	set -e
	echo -e "${GREEN}apt update && upgrade.${WHITE}"
	apt update -y && apt upgrade -y
    
	sleep 1
	echo -e "${GREEN}기타 프로그램을 설치합니다.${WHITE}"
	apt install dialog psmisc htop wget glmark2  -y
	apt install meson ninja-build sudo vim nano onboard x11-apps neofetch aptitude language-pack-gnome-ko-base locales -y 

    sleep 1
    apt install -y fonts-nanum*

    sleep 1
    apt install -y fonts-nanum*
    
    sleep 1
    apt install -y fcitx5-lib* 
    
    sleep 1
	apt install fcitx5 fcitx5-hangul -y 

    sleep 1
	echo -e "${GREEN}리브레오피스를 설치합니다.${WHITE}"
	apt install libreoffice libreoffice-help-ko -y 

    sleep 1
	apt autoremove
    sleep 1
	apt autoclean
	
	sleep 1
	echo -e 'LANG=ko_KR.UTF-8
	LANGUAGE=ko_KR.UTF-8' > /etc/default/locale

}


install_base_packages


echo -e "${GREEN}우분투 설치가 완료되었습니다.${WHITE}"
sleep 2