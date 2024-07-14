#!/bin/bash

killall conky
sleep 2s
		
GALLIUM_DRIVER=zink conky -c .config/conky/Alterf/Alterf.conf

exit
