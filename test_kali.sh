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
            read -r -p "칼리리눅스 사용자 이름(id)을 입력하세요.: " kaliname </dev/tty
			wget https://github.com/yanghoeg/Termux_XFCE/raw/main/termux_proot_kali.sh
			wget https://github.com/yanghoeg/Termux_XFCE/raw/main/termux_kali_etc.sh
            chmod +x *.sh
            ./termux_proot_kali.sh $kaliname
            ./termux_kali_etc.sh $kaliname
            rm termux_proot_kali.sh
            rm termux_kali_etc.sh
            ;;
		* ) echo -e "${GREEN}kali-linux를 설치하지 않습니다.${WHITE}"
            ;;
	esac