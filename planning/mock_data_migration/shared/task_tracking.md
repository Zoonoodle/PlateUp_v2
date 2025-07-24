# Mock Data Migration Task Tracking

## Overall Progress: 60% Complete

### Legend
- 🔴 Not Started
- 🟡 In Progress  
- 🟢 Complete
- ⚠️ Blocked
- 🚀 Priority (Focus Tab)

## IMMEDIATE PRIORITY: Focus Tab (ASAP)

### 🚀 Focus Tab Mock Data Removal
- 🟢 **NEWLY FOUND: Replace mock meal suggestions in WindowNutritionCalculator**
- 🟢 Remove static AI coaching messages
- 🟢 Create MicronutrientService with USDA API
- 🟡 Fix MealWindowManager micronutrient tracking (partial implementation)
- 🟡 Connect current window to real consumed data
- 🟡 Generate real AI insights daily (using existing AICoachingService)

### Quick Wins (Can do now)
- 🟢 Delete hard-coded insights in AICoachingInsightsViewV2
- 🟢 Remove mock micronutrients in MealWindowManager
- 🟢 Remove hardcoded meals in WindowNutritionCalculator
- 🟢 Remove hardcoded SingleFoodDatabase suggestions
- 🟢 Remove hardcoded DashboardViewModel suggestions
- 🟡 Add explicit error states (partially done)

## Phase 1: Foundation Services

### New Services Creation
- 🟢 MicronutrientService (USDA integration with API key)
- 🟢 PatternAnalysisService
- 🔴 HealthMetricsAggregator

### Decisions Made
- 🟢 Food API selected: USDA FoodData Central (free)
- 🟢 No cloud functions needed (using local Vertex AI)
- 🟢 Data retention: 2 years free / unlimited premium
- 🟢 Caching strategy defined

## Phase 2: Feature Migration

### Micronutrient System (Priority 1)
- 🟡 Create MicronutrientService
- 🔴 USDA API integration  
- 🔴 Update MealWindowManager
- 🔴 Real-time calculation engine

### Meal Suggestions (Agent 5 - Priority 1)
- 🔴 Replace WindowNutritionCalculator mock meals
- 🔴 Integrate food database for suggestions
- 🔴 AI-powered meal recommendations
- 🔴 Cache suggestions for performance

### AI Coaching (Priority 2)
- 🔴 Create PatternAnalysisService
- 🔴 Daily insight generation
- 🔴 Remove static messages
- 🔴 Implement caching (24hr)

### Progress & Analytics (Momentum Tab - Secondary)
- 🔴 Remove ProgressViewModel.loadMockData()
- 🔴 Connect to real Firebase data
- 🔴 Implement HealthMetricsService
- 🔴 Update all charts

### Dashboard Integration
- 🔴 Remove DashboardViewModel mock data
- 🔴 Connect real-time listeners
- 🔴 Implement trend calculations

## Phase 3: Testing & Optimization

### Testing
- 🔴 Temporary XCTest files with #warning
- 🔴 Manual testing by user at checkpoints
- 🔴 Remove tests after verification

### Error Handling
- 🔴 Show all errors explicitly
- 🔴 No silent failures
- 🔴 Clear error messages

## ✅ Resolved Blockers
- ✅ Food database API: USDA FoodData Central
- ✅ No Firebase schema changes needed (use existing)
- ✅ No cloud functions (already migrated)

## Next Steps
1. Start with Focus Tab quick wins
2. Build MicronutrientService with USDA
3. Create PatternAnalysisService
4. Manual testing checkpoint #1