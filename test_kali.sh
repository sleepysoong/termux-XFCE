#!/data/data/com.termux/files/usr/bin/bash
export GREEN='\033[0;32m'
export TURQ='\033[0;36m'
export URED='\033[4;31m'
export UYELLOW='\033[4;33m'
export WHITE='\033[0;37m'

username="yanghoeg"

echo -e "${GREEN}Kali-linux를 설치하겠습니까? (y/n)${WHITE}"
read yn
	case $yn in 
		y ) echo -e "${GREEN}Kali-linux를 설치합니다....${WHITE}"
			wget https://github.com/yanghoeg/Termux_XFCE/raw/main/termux_proot_kali.sh
            chmod +x *.sh
            ./termux_proot_kali.sh "$username"
            rm termux_proot_kali.sh
            ;;
		* ) echo -e "${GREEN}kali-linux를 설치하지 않습니다.${WHITE}"
            ;;
	esac