Quote of the Day for Lock Screen
===============================
Forked from [mac-lockscreen-quote-of-the-day](https://github.com/mweisz/mac-lockscreen-quote-of-the-day)
- I will be adding further functionalities and implementation support.
- My main use case is to be able to rotate lock-screen message to custom messages, preferably from a text file or external data read through an API call.

## Introduction
Provides a 'Quote of the Day' feature for the logon/lock screen of OS X.
![alt text](https://raw.githubusercontent.com/harishkarthiktk/mac-lockscreen-quote-of-the-day/master/docs/img/lockscreen.png "Login Screen with an quotation.")


## Installation and Setup.

Option 1)
Execute the script directly once using:
```bash
sudo sh change_quote.sh
```

Option 2)
- There are multiple ways of configuring a bash script to run on schedule in OS X.
- A launchd is similar to a cron job and can be configured.
- launchd can run a LaunchAgent.
- But it won't run LaunchAgents as root.
- LaunchDaemons run as root-only but will not have access to user directories.
- Therefore the script will have to be moved to a common directory, and a plist has to be configured for the LaunchDaemon to access and execute.





## Features
-  Read random line from provided text file and set it as lock screen message
-  Use publicly available quotation sources like Wikiquote.org

## Installation
Add the script to your log off hook, so that it will change your quote whenever you log off. 
