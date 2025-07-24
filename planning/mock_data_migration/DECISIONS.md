# Mock Data Migration - Decision Record

## Approved Decisions

### 1. Micronutrient Data Source
**Decision:** USDA FoodData Central API
- **Rationale:** Free, reliable, comprehensive (900k+ foods)
- **API Key:** Register at https://fdc.nal.usda.gov/api-key-signup/
- **Implementation:** Direct REST API calls with caching

### 2. Architecture (No Cloud Functions)
**Current State:** 
- Already migrated to local Firebase Vertex AI SDK
- All AI processing happens on-device
- No cloud functions infrastructure

**Data Processing:**
- Heavy calculations: Use background tasks locally
- Pattern analysis: iOS background processing (6-hour intervals)
- No need to re-implement cloud functions

### 3. Data Retention Policy
**Following MyFitnessPal model:**
- Free users: 2 years of historical data
- Premium users: Unlimited history
- Implementation: Client-side filtering (not Firestore rules)

### 4. Priority Order
1. **Focus Tab** (ASAP)
   - Current window nutrition
   - Micronutrient tracking
   - AI coaching insights
   
2. **Momentum Tab** (Secondary)
   - Progress charts
   - Health metrics
   - Weekly trends

### 5. Caching Strategy
**Light caching approach:**
- Meal images: Permanent local storage
- Today's meals: Until midnight
- USDA micronutrient data: 7 days
- AI insights: 24 hours
- Weekly trends: 6 hours
- Loading time target: 5-8 seconds

### 6. AI Insights
- **Generation:** Once daily (morning)
- **Caching:** Store similar patterns in Firestore
- **Errors:** Show explicit error messages for debugging
- **No fallback:** Let errors surface for fixing

### 7. Testing Approach
- **Automated:** Temporary XCTest files with #warning markers
- **Manual:** User will test at key checkpoints
- **Removal:** Tests deleted after manual verification

## Implementation Notes

### USDA API Integration
```swift
// Example endpoint
https://api.nal.usda.gov/fdc/v1/foods/search?api_key=YOUR_KEY&query=apple

// Response includes all micronutrients
{
  "foods": [{
    "fdcId": 123456,
    "description": "Apple, raw",
    "foodNutrients": [
      {"nutrientName": "Vitamin C", "value": 4.6, "unitName": "mg"},
      {"nutrientName": "Iron", "value": 0.12, "unitName": "mg"}
      // ... all ~30 nutrients
    ]
  }]
}
```

### Error Display Pattern
```swift
// Always show errors explicitly
if let error = viewModel.error {
    ErrorBanner(message: error.localizedDescription)
        .foregroundColor(.red)
        .padding()
}
```

## Next Steps
1. Create MicronutrientService with USDA integration
2. Start with Focus Tab mock data removal
3. Implement pattern analysis for AI insights
4. Add temporary tests for verification