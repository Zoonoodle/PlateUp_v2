# Agent 1: Progress & Analytics Migration

## Objective
Migrate ProgressViewModel and HealthMetricsService from mock data to real Firebase data sources.

## Current State
- ProgressViewModel.loadMockData() generates fake metrics
- HealthMetricsService.generateMockData() creates synthetic health data
- All Momentum tab charts display static data

## Target State
- Real-time progress metrics from Firebase
- Historical data visualization from actual user activity
- Dynamic insights based on real patterns

## Tasks

### 1. Firebase Schema Design
- [ ] Design healthMetrics collection structure
- [ ] Create progressMetrics document schema
- [ ] Plan data aggregation strategy

### 2. ProgressViewModel Migration
- [ ] Remove loadMockData() method
- [ ] Connect to FirestoreDataService
- [ ] Implement real-time listeners for:
  - Weight changes from user profile
  - Energy patterns from check-ins
  - Meal quality scores from meal analysis
  - Overall health score calculation

### 3. HealthMetricsService Refactor
- [ ] Remove generateMockData()
- [ ] Implement fetchHealthMetrics() with Firebase
- [ ] Create data aggregation methods:
  - Daily health metrics compilation
  - Energy pattern analysis
  - Sleep quality tracking
  - Weight progression tracking

### 4. Data Flow Integration
- [ ] Connect to DailyNutritionService for meal data
- [ ] Link with PatternAnalysisService for insights
- [ ] Integrate check-in data for energy/mood

### 5. Testing
- [ ] Unit tests for data transformation
- [ ] Integration tests with Firebase
- [ ] UI tests for chart rendering

## Dependencies
- FirestoreDataService
- DailyNutritionService
- PatternAnalysisService (may need creation)

## Questions
- What Firebase collections already exist for health metrics?
- How far back should historical data be displayed?
- What's the data retention policy?