#!/bin/bash
#
# Restore macOS defaults from backup
# Generated on: Thu Aug 28 06:14:22 IST 2025
#
# Run this script to restore your previous macOS settings

echo "Restoring macOS defaults from backup..."

# Press-and-hold for keys (was not set)
defaults delete "-g" "ApplePressAndHoldEnabled" 2>/dev/null || true

# AirDrop over every interface (was not set)
defaults delete "com.apple.NetworkBrowser" "BrowseAllInterfaces" 2>/dev/null || true

# Finder preferred view style (was not set)
defaults delete "com.apple.Finder" "FXPreferredViewStyle" 2>/dev/null || true

# Key repeat rate (was not set)
defaults delete "NSGlobalDomain" "KeyRepeat" 2>/dev/null || true

# Show external drives on desktop
defaults write "com.apple.finder" "ShowExternalHardDrivesOnDesktop" -bool true

# Show removable media on desktop
defaults write "com.apple.finder" "ShowRemovableMediaOnDesktop" -bool true

# Dock bottom-left hot corner action (was not set)
defaults delete "com.apple.dock" "wvous-bl-corner" 2>/dev/null || true

# Dock bottom-left hot corner modifier (was not set)
defaults delete "com.apple.dock" "wvous-bl-modifier" 2>/dev/null || true

# Safari bookmark bar visibility (was not set)
defaults delete "com.apple.Safari.plist" "ShowFavoritesBar" 2>/dev/null || true

# Safari development menu (SandboxBroker)
defaults write "com.apple.Safari.SandboxBroker" "ShowDevelopMenu" -bool false

# Safari development menu (main plist) (was not set)
defaults delete "com.apple.Safari.plist" "IncludeDevelopMenu" 2>/dev/null || true

# Safari WebKit developer extras (main plist) (was not set)
defaults delete "com.apple.Safari.plist" "WebKitDeveloperExtrasEnabledPreferenceKey" 2>/dev/null || true

# Safari WebKit2 developer extras (was not set)
defaults delete "com.apple.Safari.plist" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" 2>/dev/null || true

# Global WebKit developer extras (was not set)
defaults delete "NSGlobalDomain" "WebKitDeveloperExtras" 2>/dev/null || true

# Library folder visibility (was hidden)
chflags hidden ~/Library


echo "Restarting affected applications..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall Safari 2>/dev/null || true

echo "macOS defaults restored successfully!"
echo "Some changes may require a logout/login to take full effect."
