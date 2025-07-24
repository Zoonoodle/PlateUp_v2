#!/bin/bash

echo "Fixing duplicate GUID error in Xcode project..."

# 1. Clean all Xcode caches
echo "Step 1: Cleaning Xcode caches..."
rm -rf ~/Library/Developer/Xcode/DerivedData/PlateUp-*
rm -rf ~/Library/Caches/com.apple.dt.Xcode
rm -rf build/
rm -rf DerivedData/

# 2. Clean SPM cache for this project
echo "Step 2: Cleaning Swift Package Manager cache..."
cd PlateUp
rm -rf .swiftpm
rm -rf PlateUp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/
rm -rf PlateUp.xcodeproj/project.xcworkspace/xcuserdata/

# 3. Reset package resolved file
echo "Step 3: Resetting package resolved file..."
rm -f PlateUp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved

# 4. Kill any lingering Xcode processes
echo "Step 4: Killing Xcode processes..."
killall Xcode 2>/dev/null || true
killall com.apple.dt.SKAgent 2>/dev/null || true

# 5. Clear module cache
echo "Step 5: Clearing module cache..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex

echo "Done! Now try these steps:"
echo "1. Open PlateUp.xcodeproj in Xcode"
echo "2. Wait for package resolution to complete"
echo "3. Product → Clean Build Folder (Cmd+Shift+K)"
echo "4. Build again (Cmd+B)"