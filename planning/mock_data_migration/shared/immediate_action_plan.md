# Immediate Action Plan - Focus Tab Mock Data Removal

## Priority 1: Focus Tab Components (Fix ASAP)

### 1. Current Meal Window - Remaining Nutrition
**Mock Data Location:** `MealWindowCard.swift` - calculations may use mock data
**Fix Required:**
```swift
// Connect to real consumed meals
// Calculate actual remaining = window.target - consumed
// Update in real-time as meals are logged
```

### 2. Micronutrient Tracking
**Mock Data Location:** `MealWindowManager.getTopNeededMicronutrients()`
**Fix Required:**
1. Create `MicronutrientService` with USDA API
2. Track actual consumed micronutrients
3. Calculate real deficiencies
4. Show actual needed nutrients per window

### 3. AI Coaching Insights  
**Mock Data Location:** `AICoachingInsightsViewV2` - static messages
**Fix Required:**
1. Create `PatternAnalysisService`
2. Generate daily insights with Gemini
3. Cache for 24 hours
4. Show real patterns from user data

### 4. Upcoming Windows Micronutrients
**Mock Data Location:** `MealWindowManager` - hard-coded values
**Fix Required:**
- Use real micronutrient tracking
- Distribute daily needs across windows
- Update based on what's already consumed

## Implementation Order

### Step 1: MicronutrientService (Foundation)
```swift
class MicronutrientService: ObservableObject {
    private let usdaAPIKey = "YOUR_KEY"
    
    func fetchNutrients(for food: String) async -> MicronutrientProfile
    func calculateDailyStatus() -> MicronutrientStatus
    func getWindowRecommendations(window: MealWindow, consumed: MicronutrientProfile) -> [(String, String)]
}
```

### Step 2: Connect Real Meal Data
- Ensure `NutritionSyncService` properly tracks consumed meals
- Calculate remaining nutrition per window
- Remove any fallback to mock data

### Step 3: Pattern Analysis for AI
```swift
class PatternAnalysisService {
    func analyzeLastWeek() async -> WeeklyPatterns
    func identifyCorrelations() -> [Correlation]
    func generateInsightPrompt() -> String
}
```

### Step 4: Update Views
- Remove all static/mock data from views
- Add proper loading states
- Show errors explicitly

## Quick Win Tasks (Can do immediately)

1. **Remove Static AI Messages**
   - File: `AICoachingInsightsViewV2.swift`
   - Delete hard-coded insights
   - Add "Generating insights..." loading state

2. **Remove Mock Micronutrients**
   - File: `MealWindowManager.swift`
   - Delete `getTopNeededMicronutrients()` switch statement
   - Return empty array until service is ready

3. **Add Error States**
   - Show when services fail
   - Make debugging easier

## Manual Testing Checkpoints

**After Step 1:** Test USDA API integration
**After Step 2:** Test meal logging updates all values
**After Step 3:** Test AI insight generation
**After Step 4:** Full Focus tab testing

## Success Criteria
- [ ] No hard-coded nutrition values
- [ ] Real-time updates when logging meals  
- [ ] Actual micronutrient tracking
- [ ] Daily AI insights from real patterns
- [ ] All errors visible for debugging