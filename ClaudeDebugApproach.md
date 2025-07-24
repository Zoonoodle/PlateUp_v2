# Claude's Systematic Debugging Approach

## Overview
This document outlines a systematic approach to debugging Swift/iOS build errors using a combination of error analysis, online research, and iterative fixes.

## Debugging Cycle

### 1. Build & Capture Errors
```bash
# Build the project targeting iPhone 16 Pro simulator
xcodebuild -scheme PlateUp -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```
- Capture all build errors
- Document error types and locations
- Note any warnings that might be related

### 2. Error Analysis
For each error:
- **Identify Error Type**: Syntax, type mismatch, missing imports, etc.
- **Locate Context**: Which file, line number, surrounding code
- **Understand Root Cause**: What Swift/iOS concept is involved
- **Check Dependencies**: Are required frameworks/files imported

### 3. Research Phase
Use multiple sources:
- **Brave Search**: Search for specific error messages
- **Swift Documentation**: Official Apple docs for proper API usage
- **Stack Overflow**: Common solutions from community
- **Apple Developer Forums**: iOS-specific issues

Search queries format:
- `"[exact error message]" swift ios`
- `swift [error type] [context]`
- `swiftui [component] [issue]`

### 4. Solution Planning
Before implementing:
- **List Possible Solutions**: Rank by likelihood of success
- **Consider Side Effects**: Will fix break other parts?
- **Plan Test Strategy**: How to verify fix works
- **Document Approach**: Why choosing this solution

### 5. Implementation
- **Make Focused Changes**: One error type at a time
- **Add Missing Imports**: Check all required frameworks
- **Fix Type Issues**: Ensure proper type casting/conversion
- **Update Deprecated APIs**: Use modern Swift/iOS APIs

### 6. Verification
- **Rebuild Project**: Confirm error is resolved
- **Check New Errors**: Did fix introduce new issues?
- **Run on Simulator**: If builds, test functionality
- **Document Success**: What worked for future reference

## Common iOS/Swift Build Error Patterns

### Missing Imports
- **Error**: "Cannot find type 'X' in scope"
- **Solution**: Add appropriate `import` statement
- **Common**: UIKit, SwiftUI, AVFoundation, Speech

### Type Mismatches
- **Error**: "Cannot convert value of type 'X' to expected type 'Y'"
- **Solution**: Check type definitions, add casting if safe

### Access Control
- **Error**: "'X' is inaccessible due to 'internal' protection level"
- **Solution**: Make properties/methods public or use proper access

### SwiftUI Preview Issues
- **Error**: Preview provider build failures
- **Solution**: Ensure mock data is properly initialized

### Async/Await Issues
- **Error**: "Call can throw but is not marked with 'try'"
- **Solution**: Add proper error handling with do-catch or try?

## Research Resources

### Primary Sources
1. **Apple Developer Documentation**
   - developer.apple.com/documentation
   - Swift.org language guide

2. **Error-Specific Resources**
   - Stack Overflow (stackoverflow.com)
   - Apple Developer Forums
   - Swift Forums (forums.swift.org)

3. **SwiftUI Resources**
   - Hacking with Swift
   - SwiftUI Lab
   - Ray Wenderlich

### Search Strategies
1. **Exact Error Search**: Copy full error message
2. **Component Search**: "[Component] not working SwiftUI"
3. **API Search**: "Swift [ClassName] [methodName] usage"
4. **Version-Specific**: "iOS 17 SwiftUI [issue]"

## Debugging Checklist

- [ ] All files have necessary imports
- [ ] No circular dependencies
- [ ] All @StateObject/@ObservedObject properly initialized
- [ ] Preview providers have mock data
- [ ] Type signatures match expected values
- [ ] Async functions properly marked and called
- [ ] Access levels appropriate for usage
- [ ] No deprecated API usage
- [ ] Bundle resources properly included
- [ ] Info.plist permissions configured

## Error Log Template

```markdown
### Error #[number]
**File**: [filename]
**Line**: [line number]
**Error Message**: [exact error]
**Category**: [type/import/async/etc]
**Research Findings**: [what was discovered]
**Solution Applied**: [what was changed]
**Result**: [fixed/new error/partial fix]
```

## Success Criteria
- Project builds without errors
- All warnings addressed or documented
- App runs on iPhone 16 Pro simulator
- Core features functional
- No runtime crashes on basic navigation

## Debugging Session Log - January 2025

### Error #1: HapticManager Duplicate Declaration
**File**: HapticManager.swift
**Error**: "invalid redeclaration of 'HapticManager'"
**Cause**: Created duplicate HapticManager when one already existed in CustomTabBar.swift
**Solution**: Removed duplicate file, updated code to use existing HapticManager instance methods
**Result**: Fixed - created @StateObject instances where needed

### Error #2: MacroType Duplicate Declaration
**File**: NutritionData.swift / OptimizedCalorieRing.swift
**Error**: "invalid redeclaration of 'MacroType'"
**Cause**: Both files defined an enum named MacroType
**Solution**: Renamed enum in OptimizedCalorieRing.swift to RingMacroType
**Result**: Fixed - no naming conflict

### Error #3: TabButton Duplicate Declaration
**File**: CustomTabBar.swift / CameraTabSelector.swift
**Error**: "invalid redeclaration of 'TabButton'"
**Cause**: Multiple files defining structs with same name
**Solution**: Renamed to CameraTabButton in camera-related files
**Result**: Fixed - unique names for each component

### Error #4: VoiceWaveformView Duplicate
**File**: VoiceOnlyRecordingView.swift / VoiceContextView.swift
**Error**: "invalid redeclaration of 'VoiceWaveformView'"
**Cause**: Same struct name in multiple files
**Solution**: Renamed to VoiceOnlyWaveformView
**Result**: Fixed - no naming conflict

### Error #5: @ObservedObject with @Observable
**File**: UnifiedCameraView.swift
**Error**: "generic struct 'ObservedObject' requires that 'MealViewModel' conform to 'ObservableObject'"
**Cause**: Using @ObservedObject with new @Observable macro classes
**Solution**: Changed to use regular properties instead of @ObservedObject
**Result**: Fixed - proper usage of @Observable pattern

### Error #6: Missing Files in Target
**File**: BarcodeScannerView.swift, BarcodeScanner.swift
**Error**: "cannot find 'BarcodeScannerView' in scope"
**Cause**: Files were in wrong directory structure
**Solution**: Copied files to correct location in PlateUp/PlateUp/ directory
**Result**: Fixed - files now in correct target

### Error #7: Database Lock Error
**File**: Build System
**Error**: "accessing build database...build.db: database is locked"
**Cause**: Multiple Xcode processes running or previous build didn't release lock
**Solution**: 
  1. Killed all Xcode processes: `killall Xcode SWBBuildService Simulator`
  2. Cleaned DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/PlateUp-*`
  3. Verified no lingering build processes
**Result**: Fixed - database lock released

### Final Result: BUILD SUCCEEDED ✅
- All errors resolved including database lock
- Project builds successfully for iPhone 16 Pro simulator
- Ready for testing and further development