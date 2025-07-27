#!/bin/bash

# PlateUp v2 Codebase Cleanup Script
# This script will safely remove ~11.3GB of unnecessary files
# Run with: bash cleanup_codebase.sh

echo "🧹 PlateUp v2 Codebase Cleanup Script"
echo "This will free up approximately 11.3GB of storage"
echo ""

# Prompt for confirmation
read -p "Are you sure you want to proceed? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Cleanup cancelled."
    exit 1
fi

echo "Starting cleanup..."
echo ""

# 1. Delete build artifacts and DerivedData (11.2GB)
echo "📦 Removing build artifacts..."
rm -rf /Users/brennenprice/Documents/PlateUp_v2/PlateUp/DerivedData/
rm -rf /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build_output/
rm -rf /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build/
rm -rf /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build_fixed/
rm -rf /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build_test/
echo "✅ Build artifacts removed"

# 2. Delete build logs
echo "📝 Removing build logs..."
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build_output*.txt
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build_output*.log
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/build*.log
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/Build_*.txt
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/app_logs.txt
rm -f "/Users/brennenprice/Documents/PlateUp_v2/Build PlateUp_2025-07-25T12-06-52.txt"
echo "✅ Build logs removed"

# 3. Delete Xcode user data
echo "🔧 Removing Xcode user data..."
find /Users/brennenprice/Documents/PlateUp_v2 -name "xcuserdata" -type d -exec rm -rf {} + 2>/dev/null
echo "✅ Xcode user data removed"

# 4. Delete backup and disabled files
echo "💾 Removing backup and disabled files..."
find /Users/brennenprice/Documents/PlateUp_v2 -name "*.backup*" -type f -delete
find /Users/brennenprice/Documents/PlateUp_v2 -name "*.bak" -type f -delete
find /Users/brennenprice/Documents/PlateUp_v2 -name "*.disabled" -type f -delete
find /Users/brennenprice/Documents/PlateUp_v2 -name "*.tmp" -type f -delete
echo "✅ Backup files removed"

# 5. Delete old documentation files
echo "📄 Removing old documentation..."
docs_to_remove=(
    "AICoachPolishImplementation.md"
    "AI_COACHING_INTEGRATION_TEST.md"
    "AI_COACHING_UI_IMPLEMENTATION.md"
    "AI_ENGINEERING_COMPLETE.md"
    "AI_RESPONSE_PARSING_IMPLEMENTATION.md"
    "ANIMATION_BEHAVIOR_FIXES.md"
    "BACKEND_SETUP_COMPLETE.md"
    "BUILD_FIXES.md"
    "BUILD_FIXES_SUMMARY.md"
    "FIREBASE_INTEGRATION_COMPLETE.md"
    "FIREBASE_PACKAGE_RESOLUTION_GUIDE.md"
    "FIREBASE_SETUP_INSTRUCTIONS.md"
    "FIREBASE_SETUP_STATUS.md"
    "build_summary.md"
    "build_status_report.md"
    "meal_analysis_fix_summary.md"
)

for doc in "${docs_to_remove[@]}"; do
    rm -f "/Users/brennenprice/Documents/PlateUp_v2/PlateUp/$doc"
done
rm -f "/Users/brennenprice/Documents/PlateUp_v2/firestore-settings-fix-summary.md"
echo "✅ Old documentation removed"

# 6. Delete test/preview files
echo "🧪 Removing test preview files..."
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/ClarificationPreview.swift
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/NavigationAnimationTest.swift
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/NavigationPreview.swift
rm -f /Users/brennenprice/Documents/PlateUp_v2/PlateUp/TabIconPreview.swift
rm -f /Users/brennenprice/Documents/PlateUp_v2/test_focus_tab_integration.swift
echo "✅ Test preview files removed"

# 7. Summary
echo ""
echo "🎉 Cleanup complete!"
echo ""
echo "Storage freed: ~11.3GB"
echo ""
echo "Next steps:"
echo "1. Run 'git status' to see untracked deletions"
echo "2. Update .gitignore to prevent future accumulation"
echo "3. Consider setting up a regular cleanup schedule"
echo ""
echo "Note: Essential shell scripts and Python utilities were preserved."
echo "Review them manually if you want to remove more files."