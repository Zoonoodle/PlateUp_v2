# /build-test - Automated Build & Debug Command

## Purpose
Compile the PlateUp project, automatically handle errors, and apply debugging approaches when build fails.

## Workflow

1. **Initial Build Attempt**
   - Run xcodebuild for iPhone 16 Pro simulator
   - Capture all output and errors
   
2. **Error Analysis (if build fails)**
   - Parse error messages
   - Identify error types (missing imports, type mismatches, etc.)
   - Group similar errors
   
3. **Automated Fix Attempts**
   - Apply @ClaudeDebugApproach.md methodology
   - Fix common issues:
     - Missing imports
     - Type mismatches
     - Deprecated API usage
     - Syntax errors
   
4. **Verification**
   - Re-run build after fixes
   - Report success or remaining issues
   
5. **Detailed Report**
   - Build status
   - Errors fixed
   - Remaining issues (if any)
   - Performance metrics

## Implementation Steps

```bash
# Step 1: Run initial build
xcodebuild -scheme PlateUp -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -quiet 2>&1 | tee build_output.log

# Step 2: Check build status
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "✅ Build successful!"
    # Clean up log file
    rm build_output.log
else
    echo "❌ Build failed. Analyzing errors..."
    
    # Step 3: Parse and analyze errors
    # Extract error messages
    grep -E "(error:|warning:)" build_output.log > errors.log
    
    # Step 4: Apply automated fixes based on error patterns
    # Common fixes:
    # - Add missing imports
    # - Update deprecated APIs
    # - Fix type mismatches
    
    # Step 5: Retry build
    echo "🔧 Applying fixes and retrying build..."
    xcodebuild -scheme PlateUp -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -quiet
    
    # Step 6: Final status report
    if [ $? -eq 0 ]; then
        echo "✅ Build successful after fixes!"
    else
        echo "❌ Build still failing. Manual intervention required."
        echo "📋 Remaining errors:"
        grep "error:" build_output.log
    fi
fi
```

## Usage
Simply type `/build-test` to run the automated build and debug process.

## Benefits
- Saves time by automating common build fixes
- Consistent error handling approach
- Clear reporting of build status
- Reduces context switching between coding and debugging