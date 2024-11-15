# Termux_XFCE

https://github.com/phoenixbyrd/Termux_XFCE/tree/main의 debian proot에서 ubuntu proot로 변경하였습니다.
이외 fcitx5-hangul 등의 설치를 추가하였습니다.

저는 갤럭시 폴드6(스냅드래곤8 gen3) 갤럭시탭 s9 울트라(스냅드래곤8 gen2)를 사용하고 있습니다.
스냅드래곤8 gen3는 가속에 문제가 있어서 이 스크립트에 모두 포함하지 않았습니다.
mesa-zink를 설치하면 가속이 되지 않습니다. 이 스크립트에는 mesa-zink가 설치됩니다.

termux-native 가속 드라이버는 아래 url에서 다운받을 수 있습니다.
https://github.com/xMeM/termux-packages
위 url로 접속하여 actions -> runs에서 mesa-vulkan-icd-wrapper와 mesa관련 드라이버를 설치하면 됩니다.

추후
스냅드래곤8 gen3이 안정화 되면 스크립트를 업데이트 하겠습니다.


# Install

전체 프로그램 설치: 아래 명령어를 입력하세요

```
curl -sL https://raw.githubusercontent.com/yanghoeg/Termux_XFCE/main/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```
&nbsp;


Join the Discord for any questions, help, suggestions, etc. [https://discord.gg/pNMVrZu5dm](https://discord.gg/pNMVrZu5dm)  
위 디스코드는 코드 제작자의 디스코드 입니다.

&nbsp;

![Screenshot_20240716_163344_TermuxX11](https://github.com/user-attachments/assets/f6e46172-03e0-43c2-936f-9b5a07a1c26e)

  

&nbsp;

# Starting the desktop

During install you will recieve a popup to allow installs from termux, this will open the APK for the Termux-X11 android app. While you do not have to allow installs from termux, you will still need to install manually by using a file browser and finding the APK in your downloads folder. 
  
Use the command ```start``` to initiate a Termux-X11 session
  
This will start the termux-x11 server, XFCE4 desktop and open the Termux-X11 app right into the desktop. 

To enter the ubuntu proot install from terminal use the command ```ubuntu```

Also note, you do not need to set display in ubuntu proot as it is already set. This means you can use the terminal to start any GUI application and it will startup.

&nbsp;

# Hardware Acceleration & Proot

Here are some aliases prepared to make launching things just a little easier.

Termux XFCE:

zink - Launch apps in ubuntu proot with hardware acceleration


ubuntu proot:

zink - Launch apps in ubuntu proot with hardware acceleration
   
To enter proot use the command ```ubuntu```, from there you can install aditional software with apt and use cp2menu in termux to copy the menu items over to termux xfce menu. 

Nala has been chosen as a front end in ubuntu proot. As it is currently setup, you do not need to issue sudo prior to running apt. This allows for you to just run apt update, apt upgrade, etc without also using sudo. This is setup similar in Termux as well and works just the same.

&nbsp;

There are two scripts available for this setup as well
  
```prun```  Running this followed by a command you want to run from the ubuntu proot install will allow you to run stuff from the termux terminal without running ```ubuntu``` to get into the proot itself.
  
```cp2menu``` Running this will pop up a window allowing you to copy .desktop files from ubuntu proot into the termux xfce "start" menu so you won't need to launch them from terminal. A launcher is available in the System menu section.

&nbsp;

# Process completed (signal 9) - press Enter

install LADB from playstore or from here https://github.com/hyperio546/ladb-builds/releases

connect to wifi   
  
In split screen have one side LADB and the other side showing developer settings.
  
In developer settings, enable wireless debugging then click into there to get the port number then click pair device to get the pairing code.
  
Enter both those values into LADB
  
Once it connects run this command
  
```adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"```

You can also run adb shell from termux directly by following the guide found in this video

[https://www.youtube.com/watch?v=BHc7uvX34bM](https://www.youtube.com/watch?v=BHc7uvX34bM)
