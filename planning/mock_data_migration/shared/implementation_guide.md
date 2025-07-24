# Mock Data Migration Implementation Guide

## Quick Reference for Developers

### Identifying Mock Data
Look for these patterns:
- Methods named `loadMockData()`, `generateMockData()`
- Static properties like `.mockData`
- Hard-coded arrays of data
- Random number generation for metrics
- Time-based static content

### Migration Pattern

#### Before (Mock):
```swift
func loadMockData() {
    self.weightChange = -0.8
    self.energyStability = "High"
    self.mealQualityScore = 4.2
}
```

#### After (Real):
```swift
func loadRealData() async {
    let metrics = await healthMetricsAggregator.getLatestMetrics()
    self.weightChange = metrics.weightChange
    self.energyStability = metrics.energyStability
    self.mealQualityScore = metrics.mealQualityScore
}
```

### Service Integration Points

#### For Progress/Analytics:
```swift
// Connect to these services:
@EnvironmentObject var nutritionSync: NutritionSyncService
@EnvironmentObject var firestoreData: FirestoreDataService
@StateObject var patternAnalysis = PatternAnalysisService()
```

#### For Micronutrients:
```swift
// Use the new service:
@StateObject var micronutrientService = MicronutrientService()

// Replace hard-coded values:
let nutrients = await micronutrientService.getDeficiencies(for: window)
```

#### For AI Insights:
```swift
// Generate real insights:
let insights = await aiCoachingService.generateInsights(
    patterns: patternAnalysis.currentPatterns,
    goals: user.goals,
    recentData: nutritionSync.weeklyData
)
```

### Testing Your Migration

1. **Remove Mock Data First**
   - Comment out mock data generation
   - App should show empty states gracefully

2. **Connect Real Data**
   - Add service dependencies
   - Implement data fetching
   - Handle loading states

3. **Verify Data Flow**
   - Log a meal and see updates
   - Check all dependent views update
   - Verify calculations are correct

### Common Pitfalls

1. **Forgetting Loading States**
   ```swift
   @Published var isLoading = true
   @Published var error: Error?
   ```

2. **Not Handling Empty Data**
   ```swift
   guard !meals.isEmpty else {
       return EmptyStateView()
   }
   ```

3. **Missing Error Handling**
   ```swift
   do {
       let data = try await fetchData()
   } catch {
       // Show error state
   }
   ```

### Firebase Collections Needed

```javascript
// healthMetrics
{
  userId: "string",
  date: "timestamp",
  weight: "number",
  energy: "number",
  sleep: "number",
  metrics: {}
}

// micronutrients
{
  userId: "string", 
  date: "timestamp",
  nutrients: {
    vitaminA: { amount: "number", unit: "string" },
    // ... etc
  }
}

// patternAnalysis
{
  userId: "string",
  weekEnding: "timestamp",
  patterns: {
    mealTiming: {},
    energyCorrelations: {},
    sleepFactors: {}
  }
}
```