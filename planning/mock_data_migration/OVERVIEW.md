# Mock Data Migration Project Overview

## Project Goal
Migrate all mock data usage in PlateUp to real data sources, connecting features to actual Firebase services and real-time user data.

## Identified Mock Data Areas

### 1. **Progress & Analytics (Momentum Tab)**
- ProgressViewModel using hard-coded metrics
- HealthMetricsService generating fake data
- DashboardViewModel with static .mockData

### 2. **Micronutrient Tracking**
- MealWindowManager returning hard-coded micronutrient values
- No real micronutrient calculation from consumed meals

### 3. **AI Coaching Insights**
- AICoachingInsightsViewV2 showing static messages
- No real pattern analysis or personalized insights

### 4. **Smart Content Generation**
- DashboardViewModel.generateSmartContent() returns time-based static messages
- No real contextual analysis

### 5. **Health Metrics Charts**
- All Momentum tab charts using generateMockData()
- No real historical data visualization

### 6. **NEWLY DISCOVERED: Meal Window Suggestions**
- WindowNutritionCalculator.generateSmartSuggestions() returns hardcoded meals:
  - "Grilled Chicken Salad" (350 cal)
  - "Quinoa Buddha Bowl" (450 cal)  
  - "Greek Yogurt with Berries" (180 cal)
- Located in Services/WindowNutritionCalculator.swift lines 142-201
- Used by ActiveMealWindowCardV2 and UpcomingWindowsViewV2

## Migration Phases

### Phase 1: Foundation (Core Data Services)
- Establish real data flow from Firebase
- Create missing services for data aggregation
- Implement proper error handling

### Phase 2: Analytics & Progress
- Connect ProgressViewModel to real services
- Implement HealthMetricsService with Firebase
- Create pattern analysis algorithms

### Phase 3: Micronutrients & AI
- Build real micronutrient tracking
- Connect AI coaching to actual user patterns
- Implement smart content generation
- Replace mock meal suggestions with real AI-powered suggestions

### Phase 4: Testing & Refinement
- Comprehensive testing of all data flows
- Performance optimization
- Mock data fallback for edge cases

## Success Criteria
- All features display real user data
- No hard-coded values in production code
- Graceful fallbacks for missing data
- Performance maintained or improved