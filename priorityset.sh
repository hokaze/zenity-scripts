#!/bin/bash
#process priority setter v0.2 (zenity version) by HoKaze

#runs this script as root if not already
chk_root () {

  if [ ! $( id -u ) -eq 0 ]; then
    exec gksu "${0}" # call this script as root
    exit ${?}  # since we're 'execing' above, we wont reach this exit
               # unless something goes wrong.
  fi

}

#this calls the earlier chk_root function
chk_root

#this lists user processes in a text box
ps -eo user,pid,comm | zenity --text-info --width 300 --height 400 --title "All Processes" &

sleep 2

#requests PID of process
PID=$(zenity --entry --text "Enter the PID of the process you wish to change\nthe priority of. A list of processes can be found\nin the All Processes window." --entry-text "" --title "Enter PID")

#requests priority to set
priority=$(zenity --entry --text "Enter the priority you wish to set, the value\nmust be between -20 and 20. The higher the\nvalue, the less priority it is given." --entry-text "" --title "Enter Priority")

#sets priority
renice -n $priority $PID | zenity --text-info --title "Priority changed" --height 50 --width 300

