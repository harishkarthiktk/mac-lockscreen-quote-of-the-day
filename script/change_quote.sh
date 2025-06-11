#!/bin/bash

# Originally by Michael Weisz (feaDawn)
# June 22nd 2014

# - Modified by Harish Karthik (harishkarthiktk)

# Changed the file this location itself for ease of use and testing.
MESSAGES_FILE="./quotes.txt"

# Pick a random message
RANDOM_MESSAGE=$(shuf -n 1 "$MESSAGES_FILE")
# echo $RANDOM_MESSAGE 

# This operation requires elevation, have to handle this with a workaround.
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$RANDOM_MESSAGE"