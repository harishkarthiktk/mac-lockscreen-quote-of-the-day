Quote of the Day for Lock Screen
===============================
Forked from [mac-lockscreen-quote-of-the-day](https://github.com/mweisz/mac-lockscreen-quote-of-the-day)
- I will be adding further functionalities and implementation support.
- My main use case is to be able to rotate lock-screen message to custom messages, preferably from a text file or external data read through an API call.

## Introduction
Provides a 'Quote of the Day' feature for the logon/lock screen of OS X.
![alt text](https://raw.githubusercontent.com/harishkarthiktk/mac-lockscreen-quote-of-the-day/master/docs/img/lockscreen.png "Login Screen with an quotation.")


## Installation and Setup.

### Option 1)
Execute the script directly once using:
```bash
sudo sh change_quote.sh
```

### Option 2)
- Automate and setup a schedule that runs the bash script on OS X.
- A launchd is similar to a cron job and can be configured to run the script.
- launchd can run a LaunchAgent, it won't run the script as root.
- LaunchDaemons run as root-only but will not have access to user directories.
- Therefore the script will have to be moved to a common directory, and a plist has to be configured for the LaunchDaemon to access and execute.
- Use ./quotes.txt file for testing, but use absolute path if deploying through LaunchDaemon


**Steps:**
```bash
sudo cp ./script/change_quote.sh /Library/Scripts/change_quote.sh
sudo cp ./script/quotes.txt /Library/Scripts/quotes.txt
sudo nano /Library/LaunchDaemons/com.harishkarthiktk.quoteoftheday.plist
```
And save the following xml as the plist while running nano.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.harishkarthiktk.quoteoftheday</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Library/Scripts/change_quote.sh</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>11</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>RunAtLoad</key>
    <false/>

    <key>StandardOutPath</key>
    <string>/var/log/quoteoftheday.log</string>

    <key>StandardErrorPath</key>
    <string>/var/log/quoteoftheday.err</string>
</dict>
</plist> 
```

continue further steps:
```bash
sudo chown root:wheel /Library/LaunchDaemons/com.harishkarthiktk.quoteoftheday.plist
sudo chmod 644 /Library/LaunchDaemons/com.harishkarthiktk.quoteoftheday.plist

sudo launchctl load /Library/LaunchDaemons/com.harishkarthiktk.quoteoftheday.plist
```

NOTE: will soon provide a single bash file for the setup, in one execution to make the setup easier.

## Features
- Read random line from provided text file and set it as lock screen message.
- Intention is the cycle through multiple quotes to act as a muse.


Use with care, feel free to criticize and make modifications as needed.