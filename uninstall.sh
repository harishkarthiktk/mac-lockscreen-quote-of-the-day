#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This uninstaller must be run as root. Try: sudo $0"
    exit 1
fi

# --- Configuration ---
QUOTES_FILE="quotes.txt"
INSTALL_DIR="/Library/Scripts"
PLIST_PATH="/Library/LaunchDaemons/com.harishkarthiktk.quoteoftheday.plist"

# --- 1. Unload LaunchDaemon (all macOS versions) ---
echo "Stopping and removing LaunchDaemon service..."

# Modern macOS (10.10+)
if launchctl print system/com.harishkarthiktk.quoteoftheday &>/dev/null; then
    echo "Unloading using modern bootout method..."
    launchctl bootout system/com.harishkarthiktk.quoteoftheday 2>/dev/null
fi

# Legacy macOS fallback
if [[ -f "$PLIST_PATH" ]]; then
    echo "Unloading using legacy unload method..."
    launchctl unload -w "$PLIST_PATH" 2>/dev/null
fi

# --- 2. Remove LaunchDaemon plist ---
if [[ -f "$PLIST_PATH" ]]; then
    rm -f "$PLIST_PATH"
    echo "Removed LaunchDaemon plist"
else
    echo "No LaunchDaemon plist found"
fi

# --- 3. Save ONLY quotes.txt to current directory ---
if [[ -f "$INSTALL_DIR/$QUOTES_FILE" ]]; then
    echo "Preserving quotes file in current directory..."
    if [[ -f "./$QUOTES_FILE" ]]; then
        echo "Backup quotes.txt already exists in current directory - creating numbered backup..."
        i=1
        while [[ -f "./quotes_$i.txt" ]]; do
            ((i++))
        done
        mv "$INSTALL_DIR/$QUOTES_FILE" "./quotes_$i.txt"
        echo "Saved as quotes_$i.txt"
    else
        mv "$INSTALL_DIR/$QUOTES_FILE" ./
        echo "Saved as quotes.txt"
    fi
else
    echo "No quotes file found in installation directory"
fi

# --- 4. Remove script files ---
echo "Removing script files..."
rm -f "$INSTALL_DIR/change_quote.sh"

# --- 5. Clean up empty directory ---
if [[ -d "$INSTALL_DIR" ]] && [[ -z "$(ls -A "$INSTALL_DIR")" ]]; then
    rmdir "$INSTALL_DIR"
    echo "Removed empty scripts directory"
fi

# --- 6. Reset login window text ---
echo "Resetting login window message..."
defaults delete /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null

# --- 7. Clean up log files ---
echo "Cleaning up log files..."
rm -f /var/log/quoteoftheday.log /var/log/quoteoftheday.err

echo -e "\nUninstallation complete!"
echo "The quotes.txt file has been preserved in your current directory."
echo "All other components have been removed."

exit 0