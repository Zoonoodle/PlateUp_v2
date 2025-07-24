#!/bin/bash

# Script to test Firestore settings and capture runtime warnings
echo "Testing PlateUp Firestore settings configuration..."

# Clean build directory
echo "Cleaning build directory..."
rm -rf ~/Library/Developer/Xcode/DerivedData/PlateUp-*

# Build the app
echo "Building PlateUp..."
cd /Users/brennenprice/Documents/PlateUp_v2/PlateUp
xcodebuild -scheme PlateUp -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build > /tmp/plateup-build.log 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
    
    # Launch simulator
    echo "Launching simulator..."
    xcrun simctl boot "iPhone 16 Pro" 2>/dev/null || true
    
    # Install the app
    echo "Installing app..."
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/PlateUp-*/Build/Products/Debug-iphonesimulator -name "PlateUp.app" | head -1)
    xcrun simctl install "iPhone 16 Pro" "$APP_PATH"
    
    # Launch the app and capture logs
    echo "Launching app and capturing logs..."
    xcrun simctl launch --console-pty "iPhone 16 Pro" BiteAI.PlateUp 2>&1 | tee /tmp/plateup-runtime.log &
    
    # Give the app time to start
    sleep 5
    
    # Check for Firestore warnings
    echo -e "\n📋 Checking for Firestore settings warnings..."
    if grep -i "firestore.*settings" /tmp/plateup-runtime.log; then
        echo "⚠️  Found Firestore settings warnings"
    else
        echo "✅ No Firestore settings warnings found"
    fi
    
    # Kill the app
    xcrun simctl terminate "iPhone 16 Pro" BiteAI.PlateUp 2>/dev/null || true
    
else
    echo "❌ Build failed. Check /tmp/plateup-build.log for details"
    exit 1
fi

echo -e "\nTest complete. Full logs saved to /tmp/plateup-runtime.log"