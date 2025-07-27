#!/bin/bash
cd /Users/brennenprice/Documents/PlateUp_v2/PlateUp

# Clean build folder
xcodebuild clean -project PlateUp.xcodeproj -scheme PlateUp -quiet

# Build and capture errors
echo "Building PlateUp..."
xcodebuild -project PlateUp.xcodeproj \
           -scheme PlateUp \
           -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
           build 2>&1 | tee build_output.txt | grep -E "(error:|warning:|BUILD FAILED|BUILD SUCCEEDED)"

# Extract error details
echo -e "\n\n=== DETAILED ERRORS ==="
grep -A 5 -B 5 "error:" build_output.txt || echo "No errors found"

echo -e "\n\n=== BUILD SUMMARY ==="
tail -20 build_output.txt