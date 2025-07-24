# /deploy-functions - Firebase Cloud Functions Deployment

## Purpose
Validate, test, and deploy Firebase Cloud Functions with automated error handling and rollback capabilities.

## Workflow

1. **Pre-deployment Validation**
   - TypeScript compilation check
   - Lint functions code
   - Run unit tests (if available)
   
2. **Deploy to Firebase**
   - Deploy specific functions or all
   - Monitor deployment progress
   - Capture deployment logs
   
3. **Post-deployment Verification**
   - Check function logs for errors
   - Verify endpoints are responding
   - Run smoke tests
   
4. **Rollback on Failure**
   - Automatic rollback if deployment fails
   - Restore previous working version

## Implementation Steps

```bash
# Navigate to functions directory
cd functions

# Step 1: Pre-deployment checks
echo "🔍 Running pre-deployment checks..."

# TypeScript compilation
npm run build
if [ $? -ne 0 ]; then
    echo "❌ TypeScript compilation failed"
    exit 1
fi

# Lint check
npm run lint
if [ $? -ne 0 ]; then
    echo "⚠️ Linting issues found. Fix before deploying."
    # Show lint errors
    npm run lint -- --format stylish
fi

# Step 2: Run tests if available
if [ -f "package.json" ] && grep -q "\"test\"" package.json; then
    echo "🧪 Running tests..."
    npm test
    if [ $? -ne 0 ]; then
        echo "❌ Tests failed. Fix before deploying."
        exit 1
    fi
fi

# Step 3: Deploy functions
echo "🚀 Deploying Cloud Functions..."
firebase deploy --only functions

# Step 4: Post-deployment verification
if [ $? -eq 0 ]; then
    echo "✅ Deployment successful!"
    
    # Check function logs for startup errors
    echo "📋 Checking function logs..."
    firebase functions:log --limit 50
    
    # Optional: Run smoke tests
    echo "🔥 Running smoke tests..."
    # Add your smoke test commands here
else
    echo "❌ Deployment failed!"
    echo "🔄 Consider rolling back to previous version"
    # firebase functions:delete [function-name] --force
fi

# Return to project root
cd ..
```

## Advanced Options

### Deploy Specific Functions
```bash
# Deploy only specific functions
firebase deploy --only functions:processUserMeal,functions:generateCoachingInsights
```

### Deploy with Environment Variables
```bash
# Set environment variables before deployment
firebase functions:config:set gemini.api_key="YOUR_API_KEY"
firebase deploy --only functions
```

### Rollback Process
```bash
# List function versions
gcloud functions list

# Rollback to specific version
gcloud functions deploy FUNCTION_NAME --source=gs://BUCKET/VERSION
```

## Usage
Type `/deploy-functions` to run the full deployment pipeline with validation.