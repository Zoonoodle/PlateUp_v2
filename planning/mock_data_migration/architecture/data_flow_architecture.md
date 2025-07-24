# Data Flow Architecture for Mock Data Migration

## Overview
This document defines the architecture for migrating from mock data to real data across all PlateUp features.

## Core Services Architecture

### 1. Data Layer Services

#### FirestoreDataService (Existing)
- Primary interface to Firebase
- Handles all CRUD operations
- Manages real-time listeners

#### PatternAnalysisService (New)
```swift
class PatternAnalysisService {
    // Analyzes user data for patterns
    func analyzeMealTimingPatterns() -> MealTimingAnalysis
    func analyzeEnergyCorrelations() -> EnergyPatternAnalysis
    func analyzeSleepNutritionRelationship() -> SleepAnalysis
    func generateWeeklyReport() -> WeeklyPatternReport
}
```

#### MicronutrientService (New)
```swift
class MicronutrientService {
    // Tracks and calculates micronutrients
    func calculateMicronutrients(for meal: Meal) -> MicronutrientProfile
    func getDailyMicronutrientStatus() -> MicronutrientStatus
    func getDeficiencies() -> [MicronutrientDeficiency]
    func recommendFoods(for deficiencies: [MicronutrientDeficiency]) -> [Food]
}
```

#### HealthMetricsAggregator (New)
```swift
class HealthMetricsAggregator {
    // Aggregates health data from multiple sources
    func aggregateDailyMetrics() -> DailyHealthMetrics
    func calculateTrends() -> HealthTrends
    func generateProgressMetrics() -> ProgressMetrics
}
```

### 2. Data Flow Patterns

#### Real-time Updates
```
User logs meal → MealViewModel → NutritionSyncService → All dependent views update
                                ↓
                     FirestoreDataService
                                ↓
                     Firebase Firestore
```

#### Pattern Analysis Flow
```
Firebase Data → PatternAnalysisService → AI Coaching Service → UI Updates
                        ↓
                 Cache results for performance
```

#### Micronutrient Tracking
```
Meal logged → Food API lookup → MicronutrientService → Update all windows
                                        ↓
                              Store in Firebase for history
```

### 3. Caching Strategy

#### Local Caching
- Recent meals (7 days) cached locally
- Micronutrient database cached
- AI insights cached for 24 hours
- Pattern analysis cached for 6 hours

#### Firebase Caching
- Use Firestore offline persistence
- Cache frequently accessed documents
- Implement proper cache invalidation

### 4. Error Handling

#### Graceful Degradation
```swift
enum DataSource {
    case realtime
    case cached
    case mock // Only in dev/demo mode
}

func getData() async -> (data: Any, source: DataSource) {
    // Try realtime first
    // Fall back to cache
    // In dev mode only, fall back to mock
}
```

### 5. Performance Considerations

#### Batch Operations
- Batch Firebase writes when possible
- Aggregate calculations in Cloud Functions
- Use Firestore transactions for consistency

#### Lazy Loading
- Load dashboard data on demand
- Paginate historical data
- Stream large datasets

## Migration Strategy

### Phase 1: Foundation
1. Create new services (Pattern, Micronutrient, Aggregator)
2. Set up Firebase collections
3. Implement basic data flow

### Phase 2: Integration
1. Connect ViewModels to real services
2. Remove mock data methods
3. Implement caching

### Phase 3: Optimization
1. Add Cloud Functions for heavy calculations
2. Optimize query performance
3. Implement comprehensive error handling

### Phase 4: Testing
1. Unit test all services
2. Integration testing
3. Performance testing
4. User acceptance testing