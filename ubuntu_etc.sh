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

# 실행파일이 만들어지지 않는 것만 작성할 것

username="$1"

echo -e "${GREEN}Ubuntu proot 관련프로그램을 설치합니다(XFCE4, GPU가속기 등을 설치합니다)."

install_base_packages(){
	set -e
	echo -e "${GREEN}apt update && upgrade.${WHITE}"
	apt update -y && apt upgrade -y
    
	sleep 1
	echo -e "${GREEN}기타 프로그램을 설치합니다.${WHITE}"
	sleep 1
	apt install dialog apt-utils psmisc htop wget glmark2 -y #software-properties-common mesa-utils dbus-x11 
	sleep 1
	echo -e "${GREEN}python3 python3-pip 설치.${WHITE}"
	apt install python3 python3-pip  -y  
	sleep 1
	echo -e "${GREEN}meson 설치.${WHITE}"
	apt install meson  -y  
	
	sleep 1
	echo -e "${GREEN}ninja-build 설치.${WHITE}"
	apt install ninja-build  -y  

	sleep 1
	echo -e "${GREEN}sudo 설치.${WHITE}"
	apt install sudo  -y

	sleep 1
	echo -e "${GREEN}vim 설치.${WHITE}"
	apt install vim  -y  

	sleep 1
	echo -e "${GREEN}nano 설치.${WHITE}"
	apt install nano  -y 

	sleep 1
	echo -e "${GREEN}winbind 설치.${WHITE}"
	apt install winbind -y  

	sleep 1
	echo -e "${GREEN}onboard 설치.${WHITE}"
	apt install onboard  -y  

	sleep 1
	echo -e "${GREEN}x11-apps 설치.${WHITE}"
	apt install x11-apps -y  

	sleep 1
	echo -e "${GREEN}neofetch 설치.${WHITE}"
	apt install neofetch -y  

	sleep 1
	echo -e "${GREEN}aptitude 설치.${WHITE}"
	apt install aptitude -y  

	sleep 1
	echo -e "${GREEN}language-pack-ko 설치.${WHITE}"
	apt install language-pack-ko  -y  

	sleep 1
	echo -e "${GREEN}language-pack-gnome-ko-base 설치.${WHITE}"
	apt install language-pack-gnome-ko-base -y  

	sleep 1
	echo -e "${GREEN}locales 설치.${WHITE}"
	apt install locales -y  

    sleep 1
	echo -e "${GREEN}나눔fonts 전체설치.${WHITE}"
    apt install -y fonts-nanum* 
    
	sleep 1
	echo -e "${GREEN}im-config 설치.${WHITE}"
    apt install -y im-config 

    sleep 1
	echo -e "${GREEN}하모니카 repo 추가.${WHITE}"
	wget -qO- https://update.hamonikr.org/add-update-repo.apt | sudo -E bash - 
	
	sleep 1
	echo -e "${GREEN}nimf, nimf-libhangul 설치.${WHITE}"
    apt install -y nimf nimf-libhangul 
    
	sleep 1
	echo -e "${GREEN}fonts-noto-cjk 설치.${WHITE}"
    apt install -y fonts-noto-cjk 

	sleep 1
	echo -e "${GREEN}fonts-roboto 설치.${WHITE}"
    apt install -y fonts-roboto

	sleep 1
	echo -e "${GREEN}nimf 편집기 등록.${WHITE}"
	im-config -n nimf

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
LANGUAGE=ko_KR.UTF-8
LC_ALL=

# 편집기 설정
export GTK_IM_MODULE=nimf
export QT4_IM_MODULE="nimf"
export QT_IM_MODULE=nimf
export XMODIFIERS="@im=nimf"
nimf

# gpu 가속 설정
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export MESA_NO_ERROR=1 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2' >> /home/$username/.profile

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