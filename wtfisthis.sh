#!/bin/bash
# "wtf is" viewer - wtfisthis v0.2 by HoKaze

#tests to see if a query was made on the command line
if [ -z "$1" ]; then

	#zenity dialog for entering a acryonym to view
	acryonym=$(zenity --entry --text "WTF is..." --entry-text "" --title "wtf is this")

else
	
	#sets the page	based on the command line parameter
	manpage=$1
fi

#tests if acryonym exists in database or not and displays notification before exiting
checknym=$(wtf is $acryonym)
if [ -z "$checknym" ]; then
	zenity --error --title "wtf is this" --text="I'm sorry but I don't know what that is..."
	exit 1
fi

#zenity dialog that displays the acryonym
wtf is $acryonym | zenity --text-info --title "wtf is this" --width 400 --height 200

#closes program
exit 0
