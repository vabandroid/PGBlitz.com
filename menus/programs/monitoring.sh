#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   cmachinol
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1

 ## point to variable file for ipv4 and domain.com
source <(grep '^ .*='  /opt/appdata/plexguide/var.sh)
echo $ipv4
domain=$( cat /var/plexguide/server.domain )

 HEIGHT=10
 WIDTH=38
 CHOICE_HEIGHT=4
 BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
 TITLE="Applications - Server Monitoring"

 OPTIONS=(A "NETDATA - Basic"
          B "NETDATA - Advanced"
          Z "Exit")

 CHOICE=$(dialog --backtitle "$BACKTITLE" \
                 --title "$TITLE" \
                 --menu "$MENU" \
                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
                 "${OPTIONS[@]}" \
                 2>&1 >/dev/tty)

case $CHOICE in

	A)
		display=NETDATA-Basic
		program=netdata
		port=19999
		dialog --infobox "Installing: $display" 3 30
		skip=yes
		ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags netdata &>/dev/null &
		sleep 2
		cronskip=yes
		;;

	B)
		display=NETDATA-Advanced
		program="netdata"
		port="9090"
		dialog --infobox "Installing: $display" 3 38
		ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags "monitor" &>/dev/null &
		sleep 8
		cronskip=yes
		;;

	Z)
       exit 0 ;;
esac

########## Cron Job a Program
echo "$program" > /tmp/program_var
if [ "$cronskip" == "yes" ]; then
    clear 1>/dev/null 2>&1
else
	bash /opt/plexguide/menus/programs/support.sh
fi 

# 8080 3000 9090
#rm -f /tmp/program
#for prgm in $program; do
#	echo "$prgm" >> /tmp/program
#	done

#rm -f /tmp/port
#for p in $port; do
#	echo "$p" >> /tmp/port
#	done
#"${program[@]}" "${port[@]}"

echo "$program" > /tmp/program
echo "$port" > /tmp/port

#### Pushes Out Ending
bash /opt/plexguide/menus/programs/ending.sh

#### recall itself to loop unless user exits
bash /opt/plexguide/menus/programs/monitoring.sh
