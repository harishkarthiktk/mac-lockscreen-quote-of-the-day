#!/bin/bash

# Originally by Michael Weisz (feaDawn)
# June 22nd 2014

# - Modified by Harish Karthik (harishkarthiktk)

# Uncomment and use ./quotes.txt file for testing, but use absolute path if deploying through LaunchDaemon
# MESSAGES_FILE="./quotes.txt"
MESSAGES_FILE="/Library/Scripts/quotes.txt"

# Pick a random message
RANDOM_MESSAGE=$(shuf -n 1 "$MESSAGES_FILE")
# echo $RANDOM_MESSAGE 

# This operation requires elevation, have to handle this with a workaround.
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$RANDOM_MESSAGE"