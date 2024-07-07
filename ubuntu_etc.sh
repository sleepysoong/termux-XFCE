#!/bin/bash
export GREEN='\033[0;32m'
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
    echo "ERROR: ubuntu 추가프로그램 설치에 실패하였습니다."
    echo "위 error message를 참고하세요"
  fi
}

trap finish EXIT

username="$1"

echo -e "${GREEN}Ubuntu proot 관련프로그램을 설치합니다(XFCE4, GPU가속기 등을 설치합니다)."

install_base_packages(){
	set -e
	echo -e "${GREEN}apt update && upgrade.${WHITE}"
	apt update -y && apt upgrade -y
    
	sleep 1
	echo -e "${GREEN}기타 프로그램을 설치합니다.${WHITE}"
	sleep 1
	apt install dialog psmisc htop wget glmark2 -y 
	sleep 1
	apt install meson  -y  
	sleep 1
	apt install ninja-build  -y  

	sleep 1
	apt install sudo  -y  

	sleep 1
	apt install vim  -y  

	sleep 1
	apt install nano  -y  

	sleep 1
	apt install onboard  -y  

	sleep 1
	apt install x11-apps -y  

	sleep 1
	apt install neofetch -y  

	sleep 1
	apt install aptitude  -y  

	sleep 1
	apt install language-pack-ko  -y  

	sleep 1
	apt install language-pack-gnome-ko-base -y  

	sleep 1
	apt install locales -y  

	sleep 1
	echo -e '
#한국어 설정
LANG=ko_KR.UTF-8
LC_CTYPE=ko_KR.UTF-8
LC_NUMERIC=ko_KR.UTF-8
LC_TIME=ko_KR.UTF-8
LC_COLLATE=ko_KR.UTF-8
LC_MONETARY=ko_KR.UTF-8
LC_MESSAGES=ko_KR.UTF-8
LC_PAPER=ko_KR.UTF-8
LC_NAME=ko_KR.UTF-8
LC_ADDRESS=ko_KR.UTF-8
LC_TELEPHONE=ko_KR.UTF-8
LC_MEASUREMENT=ko_KR.UTF-8
LC_IDENTIFICATION=ko_KR.UTF-8
LANGUAGE=ko_KR.UTF-8' >> /home/$username/.profile

    sleep 1
    apt install -y fonts-nanum* 
    
	sleep 1
    apt install -y im-config 
    sleep 1
	wget -qO- https://update.hamonikr.org/add-update-repo.apt | sudo -E bash - 
	sleep 1
    apt install -y nimf nimf-libhangul fonts-noto-cjk fonts-roboto 
    
	sleep 1
	im-config -n nimf

	echo -e '
# 편집기 설정
export GTK_IM_MODULE=nimf
export QT4_IM_MODULE="nimf"
export QT_IM_MODULE=nimf
export XMODIFIERS="@im=nimf"
nimf' >> /home/$username/.profile

    sleep 1
	echo -e "${GREEN}리브레오피스를 설치합니다.${WHITE}"
	apt install libreoffice libreoffice-help-ko -y  
	
	sleep 1
	echo -e "${GREEN}chromium을 설치합니다.${WHITE}"
	apt install chromium-browser -y  

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