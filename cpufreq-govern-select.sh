#!/bin/bash
# CPU Frequency governor script by HoKaze (alt version)
# This version is inferior but on my system does not require root/sudo

#creates zenity radiolist for all governors except userspace
governor=$(zenity --title="CPU Frequency Selector" --height=220 --text "Please select a CPU frequency governor. \n(Recommended option is Ondemand)" --list --separator=" & " --radiolist --column="tick" --column=option powersave "powersave" ondemand "ondemand" conservative "conservative" performance "performance")

cpufreq-set -c 0 -g $governor &
cpufreq-set -c 1 -g $governor &
