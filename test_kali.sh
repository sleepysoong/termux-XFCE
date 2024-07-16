#!/data/data/com.termux/files/usr/bin/bash

username="yanghoeg"

read yn
	case $yn in 
		y ) echo -e "${GREEN}Kali-linux를 설치합니다....${WHITE}"
			wget https://github.com/yanghoeg/Termux_XFCE/raw/main/termux_proot_kali.sh
            chmod +x *.sh
            ./termux_proot_kali.sh "$username"
            rm termux_proot_kali.sh

		* ) echo -e "${GREEN}kali-linux를 설치하지 않습니다.${WHITE}";;
	esac