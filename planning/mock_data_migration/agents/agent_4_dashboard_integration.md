# Agent 4: Dashboard & Real-time Integration

## Objective
Connect DashboardViewModel to real data sources and ensure all dashboard features use live data.

## Current State
- DashboardViewModel uses static .mockData
- weeklyTrend and yesterdaysImpact are hard-coded
- No real-time updates from meal logging

## Target State
- Live dashboard data from Firebase
- Real-time updates when meals are logged
- Accurate weekly trends and daily impact

## Tasks

### 1. Remove Mock Data
- [ ] Delete all .mockData static properties
- [ ] Remove mock data generation methods
- [ ] Identify all mock data usage points

### 2. Firebase Integration
- [ ] Create dashboard data listeners
- [ ] Implement real-time sync:
  ```swift
  func setupRealtimeListeners() {
      // Listen to today's meals
      mealViewModel.$consumedMeals
          .sink { [weak self] meals in
              self?.updateDashboardMetrics(meals)
          }
          .store(in: &cancellables)
      
      // Listen to nutrition updates
      nutritionSync.nutritionUpdates
          .sink { [weak self] update in
              self?.refreshDashboard()
          }
          .store(in: &cancellables)
  }
  ```

### 3. Weekly Trend Calculation
- [ ] Implement real weekly trend analysis
- [ ] Calculate from actual meal history
- [ ] Show percentage changes
- [ ] Include all relevant metrics

### 4. Yesterday's Impact
- [ ] Fetch yesterday's complete data
- [ ] Calculate actual impact metrics
- [ ] Compare to weekly average
- [ ] Generate meaningful insights

### 5. Performance Optimization
- [ ] Implement data caching
- [ ] Minimize Firebase reads
- [ ] Batch updates for efficiency
- [ ] Handle offline scenarios

### 6. Testing
- [ ] Test real-time updates
- [ ] Verify calculation accuracy
- [ ] Test edge cases (no data, partial data)

## Dependencies
- FirestoreDataService
- MealViewModel
- NutritionSyncService
- Analytics aggregation

## Questions
- How should we handle incomplete data days?
- What's the retention period for dashboard data?
- Should calculations be done client-side or in Cloud Functions?