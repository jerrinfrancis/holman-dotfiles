#!/bin/bash
#
# Create a complete backup of important macOS defaults
#
# This script creates a comprehensive backup of macOS system preferences
# that are commonly modified by dotfiles and development setups.

set -e

BACKUP_DIR="$HOME/.dotfiles/backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/full_macos_backup_$TIMESTAMP.sh"

echo "🔄 Creating comprehensive macOS defaults backup..."
echo "📁 Backup will be saved to: $BACKUP_FILE"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create the backup restoration script header
cat > "$BACKUP_FILE" << EOF
#!/bin/bash
#
# Comprehensive macOS defaults restoration script
# Generated on: $(date)
#
# This script will restore your macOS system preferences to their
# state before running dotfiles installation.

echo "🔄 Restoring macOS defaults from comprehensive backup..."

EOF

# Function to safely backup any defaults setting
backup_any_setting() {
    local domain="$1"
    local key="$2"
    local description="$3"
    local type="$4"  # optional: -bool, -int, -string, etc.
    
    echo "  📋 Backing up: $description"
    
    # Try to read the current value
    if defaults read "$domain" "$key" >/dev/null 2>&1; then
        current_value=$(defaults read "$domain" "$key" 2>/dev/null)
        echo "# $description" >> "$BACKUP_FILE"
        
        if [ -n "$type" ]; then
            echo "defaults write \"$domain\" \"$key\" $type \"$current_value\"" >> "$BACKUP_FILE"
        else
            # Auto-detect type and format value appropriately
            if [[ "$current_value" =~ ^[0-9]+$ ]]; then
                echo "defaults write \"$domain\" \"$key\" -int $current_value" >> "$BACKUP_FILE"
            elif [[ "$current_value" == "1" ]] || [[ "$current_value" == "0" ]]; then
                if [ "$current_value" = "1" ]; then
                    echo "defaults write \"$domain\" \"$key\" -bool true" >> "$BACKUP_FILE"
                else
                    echo "defaults write \"$domain\" \"$key\" -bool false" >> "$BACKUP_FILE"
                fi
            else
                echo "defaults write \"$domain\" \"$key\" \"$current_value\"" >> "$BACKUP_FILE"
            fi
        fi
    else
        echo "# $description (was not set)" >> "$BACKUP_FILE"
        echo "defaults delete \"$domain\" \"$key\" 2>/dev/null || true" >> "$BACKUP_FILE"
    fi
    echo "" >> "$BACKUP_FILE"
}

echo "📋 Backing up system-wide settings..."

# Global/System settings
backup_any_setting "NSGlobalDomain" "ApplePressAndHoldEnabled" "Press-and-hold for keys"
backup_any_setting "NSGlobalDomain" "KeyRepeat" "Key repeat rate"
backup_any_setting "NSGlobalDomain" "InitialKeyRepeat" "Initial key repeat delay"
backup_any_setting "NSGlobalDomain" "WebKitDeveloperExtras" "Global WebKit developer extras"
backup_any_setting "NSGlobalDomain" "AppleShowAllExtensions" "Show all file extensions"
backup_any_setting "NSGlobalDomain" "AppleShowScrollBars" "Scroll bar visibility"

echo "📋 Backing up Finder settings..."

# Finder settings
backup_any_setting "com.apple.finder" "ShowExternalHardDrivesOnDesktop" "Show external drives on desktop"
backup_any_setting "com.apple.finder" "ShowRemovableMediaOnDesktop" "Show removable media on desktop"
backup_any_setting "com.apple.finder" "ShowHardDrivesOnDesktop" "Show hard drives on desktop"
backup_any_setting "com.apple.finder" "ShowMountedServersOnDesktop" "Show mounted servers on desktop"
backup_any_setting "com.apple.Finder" "FXPreferredViewStyle" "Finder preferred view style"
backup_any_setting "com.apple.finder" "FXDefaultSearchScope" "Finder default search scope"
backup_any_setting "com.apple.finder" "ShowPathbar" "Finder path bar"
backup_any_setting "com.apple.finder" "ShowStatusBar" "Finder status bar"
backup_any_setting "com.apple.finder" "_FXShowPosixPathInTitle" "Show full path in Finder title"

echo "📋 Backing up Dock settings..."

# Dock settings
backup_any_setting "com.apple.dock" "autohide" "Dock auto-hide"
backup_any_setting "com.apple.dock" "autohide-delay" "Dock auto-hide delay"
backup_any_setting "com.apple.dock" "autohide-time-modifier" "Dock auto-hide animation time"
backup_any_setting "com.apple.dock" "tilesize" "Dock tile size"
backup_any_setting "com.apple.dock" "magnification" "Dock magnification"
backup_any_setting "com.apple.dock" "orientation" "Dock orientation"
backup_any_setting "com.apple.dock" "wvous-bl-corner" "Dock bottom-left hot corner action"
backup_any_setting "com.apple.dock" "wvous-bl-modifier" "Dock bottom-left hot corner modifier"
backup_any_setting "com.apple.dock" "wvous-br-corner" "Dock bottom-right hot corner action"
backup_any_setting "com.apple.dock" "wvous-br-modifier" "Dock bottom-right hot corner modifier"
backup_any_setting "com.apple.dock" "wvous-tl-corner" "Dock top-left hot corner action"
backup_any_setting "com.apple.dock" "wvous-tl-modifier" "Dock top-left hot corner modifier"
backup_any_setting "com.apple.dock" "wvous-tr-corner" "Dock top-right hot corner action"
backup_any_setting "com.apple.dock" "wvous-tr-modifier" "Dock top-right hot corner modifier"

echo "📋 Backing up Safari settings..."

# Safari settings
backup_any_setting "com.apple.Safari" "ShowFavoritesBar" "Safari bookmark bar visibility"
backup_any_setting "com.apple.Safari" "IncludeDevelopMenu" "Safari development menu"
backup_any_setting "com.apple.Safari" "WebKitDeveloperExtrasEnabledPreferenceKey" "Safari WebKit developer extras"
backup_any_setting "com.apple.Safari" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" "Safari WebKit2 developer extras"
backup_any_setting "com.apple.Safari.SandboxBroker" "ShowDevelopMenu" "Safari development menu (SandboxBroker)"

echo "📋 Backing up network and system settings..."

# Network and system settings
backup_any_setting "com.apple.NetworkBrowser" "BrowseAllInterfaces" "AirDrop over every interface"
backup_any_setting "com.apple.screencapture" "location" "Screenshot save location"
backup_any_setting "com.apple.screencapture" "type" "Screenshot file format"
backup_any_setting "com.apple.screencapture" "disable-shadow" "Screenshot drop shadow"

echo "📋 Backing up Terminal settings..."

# Terminal settings
backup_any_setting "com.apple.terminal" "Default Window Settings" "Terminal default window settings"
backup_any_setting "com.apple.terminal" "Startup Window Settings" "Terminal startup window settings"

echo "📋 Backing up menu bar and control center..."

# Menu bar and control center
backup_any_setting "com.apple.controlcenter" "BatteryShowPercentage" "Battery percentage in menu bar"
backup_any_setting "com.apple.menuextra.clock" "DateFormat" "Menu bar clock format"

# Check Library folder visibility
echo "  📋 Backing up: Library folder visibility"
if [[ $(ls -lOd ~/Library 2>/dev/null | awk '{print $5}') == *"hidden"* ]]; then
    echo "# Library folder visibility (was hidden)" >> "$BACKUP_FILE"
    echo "chflags hidden ~/Library" >> "$BACKUP_FILE"
else
    echo "# Library folder visibility (was visible)" >> "$BACKUP_FILE"
    echo "chflags nohidden ~/Library" >> "$BACKUP_FILE"
fi
echo "" >> "$BACKUP_FILE"

# Add system restart commands to the backup file
cat >> "$BACKUP_FILE" << 'EOF'

echo "🔄 Restarting affected applications..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall Safari 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall ControlCenter 2>/dev/null || true

echo "✅ macOS defaults restored successfully!"
echo "ℹ️  Some changes may require a logout/login to take full effect."
echo "🔄 You may also want to restart your computer for all changes to apply."
EOF

# Make the backup file executable
chmod +x "$BACKUP_FILE"

echo ""
echo "✅ Comprehensive backup completed successfully!"
echo "📁 Backup saved to: $BACKUP_FILE"
echo ""
echo "📋 This backup includes:"
echo "   • System-wide preferences (key repeat, file extensions, etc.)"
echo "   • Finder settings (desktop icons, view styles, etc.)"
echo "   • Dock configuration (size, position, hot corners)"
echo "   • Safari development settings"
echo "   • Network and AirDrop settings"
echo "   • Screenshot and Terminal preferences"
echo "   • Menu bar and Control Center settings"
echo ""
echo "🔄 To restore these settings later, run:"
echo "   $BACKUP_FILE"
