#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo $0"
    exit 1
fi

# --- Step 1: Copy files ---
echo "Copying script and quotes.txt to /Library/Scripts/..."
mkdir -p /Library/Scripts/
cp ./script/change_quote.sh /Library/Scripts/change_quote.sh
cp ./script/quotes.txt /Library/Scripts/quotes.txt
chmod +x /Library/Scripts/change_quote.sh

# --- Step 2: Create LaunchDaemon plist ---
echo "Creating LaunchDaemon plist..."
LAUNCH_DAEMON_PATH="/Library/LaunchDaemons/com.harishkarthiktk.quoteoftheday.plist"

cat > "$LAUNCH_DAEMON_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
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
EOF

# --- Step 3: Set permissions ---
echo "Setting permissions..."
chown root:wheel "$LAUNCH_DAEMON_PATH"
chmod 644 "$LAUNCH_DAEMON_PATH"

# --- Step 4: Load the daemon ---
echo "Loading LaunchDaemon..."
if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 13 ]]; then
    # Modern macOS (Ventura+)
    sudo launchctl bootstrap system "$LAUNCH_DAEMON_PATH" || {
        echo "Bootstrap failed. Trying alternative method..."
        sudo launchctl load -w "$LAUNCH_DAEMON_PATH"
    }
else
    # Older macOS
    sudo launchctl load -w "$LAUNCH_DAEMON_PATH"
fi

echo "----> Setup complete! Verify with:"
echo "----> sudo launchctl list | grep harishkarthiktk"
echo "----> To test immediately: sudo /Library/Scripts/change_quote.sh"