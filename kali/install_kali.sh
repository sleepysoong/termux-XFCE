#!/data/data/com.termux/files/usr/bin/bash
export GREEN='\033[0;32m'
export TURQ='\033[0;36m'
export URED='\033[4;31m'
export UYELLOW='\033[4;33m'
export WHITE='\033[0;37m'


echo -e "${GREEN}Kali-linux를 설치하겠습니까? (y/n)${WHITE}"
read yn
	case $yn in 
		y ) echo -e "${GREEN}Kali-linux를 설치합니다....${WHITE}"
            read -r -p "termux에서 사용하는 이름(id)을 입력하세요.: " username </dev/tty
            read -r -p "칼리리눅스 사용자 이름(id)을 입력하세요.: " kaliname </dev/tty
			wget https://github.com/KIMSEONGHA2223/Termux_edit/raw/main/kali_install.sh
			wget https://github.com/KIMSEONGHA2223/Termux_edit/raw/main/kali_install_app.sh
            chmod +x *.sh
            ./kali_install.sh $username $kaliname
            ./kali_install_app.sh $kaliname
            rm kali_install.sh
            rm kali_install_app.sh
            ;;
		* ) echo -e "${GREEN}kali-linux를 설치하지 않습니다.${WHITE}"
            ;;
	esac
