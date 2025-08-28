#!/bin/bash
#
# Backup current macOS defaults before running set-defaults.sh
#
# This script backs up all the settings that will be modified by set-defaults.sh
# so you can restore them later if needed.

set -e

BACKUP_DIR="$HOME/.dotfiles/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/macos_defaults_backup_$TIMESTAMP.sh"

echo "Creating backup of current macOS defaults..."
echo "Backup will be saved to: $BACKUP_FILE"

# Create the backup restoration script
cat > "$BACKUP_FILE" << 'EOF'
#!/bin/bash
#
# Restore macOS defaults from backup
# Generated on: TIMESTAMP_PLACEHOLDER
#
# Run this script to restore your previous macOS settings

echo "Restoring macOS defaults from backup..."

EOF

# Function to backup a setting and add restore command
backup_setting() {
    local domain="$1"
    local key="$2"
    local description="$3"
    
    echo "Backing up: $description"
    
    # Try to read the current value
    current_value=$(defaults read "$domain" "$key" 2>/dev/null || echo "NOT_SET")
    
    if [ "$current_value" = "NOT_SET" ]; then
        echo "# $description (was not set)" >> "$BACKUP_FILE"
        echo "defaults delete \"$domain\" \"$key\" 2>/dev/null || true" >> "$BACKUP_FILE"
    else
        echo "# $description" >> "$BACKUP_FILE"
        echo "defaults write \"$domain\" \"$key\" \"$current_value\"" >> "$BACKUP_FILE"
    fi
    echo "" >> "$BACKUP_FILE"
}

# Function to backup boolean settings
backup_bool_setting() {
    local domain="$1"
    local key="$2"
    local description="$3"
    
    echo "Backing up: $description"
    
    current_value=$(defaults read "$domain" "$key" 2>/dev/null || echo "NOT_SET")
    
    if [ "$current_value" = "NOT_SET" ]; then
        echo "# $description (was not set)" >> "$BACKUP_FILE"
        echo "defaults delete \"$domain\" \"$key\" 2>/dev/null || true" >> "$BACKUP_FILE"
    else
        echo "# $description" >> "$BACKUP_FILE"
        if [ "$current_value" = "1" ]; then
            echo "defaults write \"$domain\" \"$key\" -bool true" >> "$BACKUP_FILE"
        else
            echo "defaults write \"$domain\" \"$key\" -bool false" >> "$BACKUP_FILE"
        fi
    fi
    echo "" >> "$BACKUP_FILE"
}

# Function to backup integer settings
backup_int_setting() {
    local domain="$1"
    local key="$2"
    local description="$3"
    
    echo "Backing up: $description"
    
    current_value=$(defaults read "$domain" "$key" 2>/dev/null || echo "NOT_SET")
    
    if [ "$current_value" = "NOT_SET" ]; then
        echo "# $description (was not set)" >> "$BACKUP_FILE"
        echo "defaults delete \"$domain\" \"$key\" 2>/dev/null || true" >> "$BACKUP_FILE"
    else
        echo "# $description" >> "$BACKUP_FILE"
        echo "defaults write \"$domain\" \"$key\" -int $current_value" >> "$BACKUP_FILE"
    fi
    echo "" >> "$BACKUP_FILE"
}

# Replace timestamp placeholder
sed -i '' "s/TIMESTAMP_PLACEHOLDER/$(date)/" "$BACKUP_FILE"

# Backup all settings that will be modified by set-defaults.sh

# Press-and-hold for keys
backup_bool_setting "-g" "ApplePressAndHoldEnabled" "Press-and-hold for keys"

# AirDrop over every interface
backup_int_setting "com.apple.NetworkBrowser" "BrowseAllInterfaces" "AirDrop over every interface"

# Finder list view preference
backup_setting "com.apple.Finder" "FXPreferredViewStyle" "Finder preferred view style"

# Key repeat rate
backup_int_setting "NSGlobalDomain" "KeyRepeat" "Key repeat rate"

# Show external drives on desktop
backup_bool_setting "com.apple.finder" "ShowExternalHardDrivesOnDesktop" "Show external drives on desktop"

# Show removable media on desktop
backup_bool_setting "com.apple.finder" "ShowRemovableMediaOnDesktop" "Show removable media on desktop"

# Dock hot corner (bottom-left corner)
backup_int_setting "com.apple.dock" "wvous-bl-corner" "Dock bottom-left hot corner action"

# Dock hot corner modifier (bottom-left)
backup_int_setting "com.apple.dock" "wvous-bl-modifier" "Dock bottom-left hot corner modifier"

# Safari bookmark bar
backup_bool_setting "com.apple.Safari.plist" "ShowFavoritesBar" "Safari bookmark bar visibility"

# Safari development menu (SandboxBroker)
backup_bool_setting "com.apple.Safari.SandboxBroker" "ShowDevelopMenu" "Safari development menu (SandboxBroker)"

# Safari development menu (main plist)
backup_bool_setting "com.apple.Safari.plist" "IncludeDevelopMenu" "Safari development menu (main plist)"

# Safari WebKit developer extras (main plist)
backup_bool_setting "com.apple.Safari.plist" "WebKitDeveloperExtrasEnabledPreferenceKey" "Safari WebKit developer extras (main plist)"

# Safari WebKit2 developer extras
backup_bool_setting "com.apple.Safari.plist" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" "Safari WebKit2 developer extras"

# Global WebKit developer extras
backup_bool_setting "NSGlobalDomain" "WebKitDeveloperExtras" "Global WebKit developer extras"

# Check Library folder visibility
echo "Backing up: Library folder visibility"
if [[ $(ls -lOd ~/Library | awk '{print $5}') == *"hidden"* ]]; then
    echo "# Library folder visibility (was hidden)" >> "$BACKUP_FILE"
    echo "chflags hidden ~/Library" >> "$BACKUP_FILE"
else
    echo "# Library folder visibility (was visible)" >> "$BACKUP_FILE"
    echo "chflags nohidden ~/Library" >> "$BACKUP_FILE"
fi
echo "" >> "$BACKUP_FILE"

# Add execution instructions to the backup file
cat >> "$BACKUP_FILE" << 'EOF'

echo "Restarting affected applications..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall Safari 2>/dev/null || true

echo "macOS defaults restored successfully!"
echo "Some changes may require a logout/login to take full effect."
EOF

# Make the backup file executable
chmod +x "$BACKUP_FILE"

echo ""
echo "✅ Backup completed successfully!"
echo "📁 Backup saved to: $BACKUP_FILE"
echo ""
echo "To restore your settings later, run:"
echo "   $BACKUP_FILE"
echo ""
echo "You can now safely run the dotfiles installation."
