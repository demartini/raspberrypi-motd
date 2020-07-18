#!/bin/bash
#
# Script Name  : motd.sh
# Description  : A custom message of the day (MOTD) for Raspberry Pi OS.
# Version      : 0.1.0
# Author       : Iolar Demartini Junior
# URL          : https://github.com/demartini/raspberrypi-motd

# Clean the console before printing the message.
clear

# Colors
RED=$(tput setaf 1)
GRE=$(tput setaf 2)
YEL=$(tput setaf 3)
CYA=$(tput setaf 6)
WHI=$(tput setaf 7)

# Spaces
SPC="                         "

# Date
VAR_DATE="$(date +"%A, %d %B %Y, %T")"

# User
VAR_USER="$(whoami)"

# DNS Servers
VAR_DNS_SERVERS="$(grep nameserver /etc/resolv.conf | awk '{print $2}' | tr '\r\n' ' ')"

# Disk Space
VAR_DISK_SPACE="$(df -h ~ | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB",$2,$3,$4; }')"

# Hostname
VAR_HOSTNAME="$(hostname)"

# LAN IP
VAR_LAN_IP="$(hostname -I)"

# Last Login
VAR_LAST_LOGIN="$(last -i "$USER" -F | grep -v 'still logged' | head -1 | awk '{print $6,$5,$8,$7}')"
VAR_LAST_LOGIN_IP="$(last -i "$USER" -F | grep -v 'still logged' | head -1 | awk '{print $3}')"

# Load Average
VAR_LOAD_AVERAGE="$(uptime | sed 's/^.*\(load*\)/\1/g' | awk '{printf "%s (1min) %s (5min) %s (15min)", substr($3,0,5),substr($4,0,5),substr($5,0,5); }')"

# Memory
VAR_MEMORY="$(free -m | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }')"

# Running Processes
VAR_RUNNING_PROCESSES="$(ps ax | wc -l | tr -d " ")"

# Logged Users
VAR_LOGGED_USERS="$(who | grep -c .)"

# Temperature
VAR_TEMPERATURE="$(/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9")°C"

# Uptime
VAR_UPTIME="$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/') ($(date -d "@""$(grep btime /proc/stat | cut -d " " -f 2)" +"%Y/%m/%d %H:%M:%S"))"

# WAN IP
VAR_WAN_IP="$(curl -s ifconfig.me | tail)"

# Message
echo -e "\n"
echo -e "${SPC}${CYA}Welcome back, ${VAR_USER}!"
echo -e "${SPC}${CYA}${VAR_DATE}"
echo -e ""
echo -e "${GRE}       .~~.   .~~.       ${YEL}Uptime.............:${WHI} ${VAR_UPTIME}"
echo -e "${GRE}      '. \ ' ' / .'      ${YEL}Last Login.........:${WHI} ${VAR_LAST_LOGIN} from ${VAR_LAST_LOGIN_IP}"
echo -e "${RED}       .~ .~~~..~.       ${YEL}Logged Users.......:${WHI} ${VAR_LOGGED_USERS} users logged in."
echo -e "${RED}      : .~.'~'.~. :      "
echo -e "${RED}     ~ (   ) (   ) ~     ${YEL}Running Processes..:${WHI} ${VAR_RUNNING_PROCESSES}"
echo -e "${RED}    ( : '~'.~.'~' : )    ${YEL}Load Average.......:${WHI} ${VAR_LOAD_AVERAGE}"
echo -e "${RED}     ~ .~ (   ) ~. ~     ${YEL}Memory.............:${WHI} ${VAR_MEMORY}"
echo -e "${RED}      (  : '~' :  )      ${YEL}Disk Space.........:${WHI} ${VAR_DISK_SPACE}"
echo -e "${RED}       '~ .~~~. ~'       ${YEL}Temperature........:${WHI} ${VAR_TEMPERATURE}"
echo -e "${RED}           '~'           "
echo -e "${SPC}${YEL}Hostname...........:${WHI} ${VAR_HOSTNAME}"
echo -e "${SPC}${YEL}LAN IP.............:${WHI} ${VAR_LAN_IP}"
echo -e "${SPC}${YEL}WAN IP.............:${WHI} ${VAR_WAN_IP}"
echo -e "${SPC}${YEL}DNS Servers........:${WHI} ${VAR_DNS_SERVERS}"
echo -e "\n"
