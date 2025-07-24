# Agent 2: Micronutrient Tracking System

## Objective
Build real micronutrient tracking to replace hard-coded values in MealWindowManager.

## Current State
- getTopNeededMicronutrients() returns static values based on window name
- No actual tracking of consumed micronutrients
- No real recommendations based on deficiencies

## Target State
- Real-time micronutrient calculation from consumed meals
- Dynamic recommendations based on actual deficiencies
- Window-specific micronutrient distribution

## Tasks

### 1. Micronutrient Service Creation
- [ ] Create MicronutrientService class
- [ ] Define micronutrient data model
- [ ] Implement tracking for key nutrients:
  - Vitamins (A, B-complex, C, D, E, K)
  - Minerals (Iron, Calcium, Magnesium, Zinc)
  - Other (Omega-3, Fiber, etc.)

### 2. Food Database Integration
- [ ] Connect to food database API for nutrient data
- [ ] Create local caching strategy
- [ ] Handle custom/unknown foods

### 3. Calculation Engine
- [ ] Calculate daily micronutrient intake
- [ ] Track per-meal-window consumption
- [ ] Identify deficiencies in real-time
- [ ] Generate window-specific recommendations

### 4. MealWindowManager Update
- [ ] Remove hard-coded micronutrient values
- [ ] Connect to MicronutrientService
- [ ] Implement dynamic recommendations:
  ```swift
  func getTopNeededMicronutrients(for window: MealWindow) -> [(String, String)] {
      return micronutrientService.getDeficiencies(
          considering: window,
          consumedToday: nutritionSync.getConsumedMicronutrients()
      )
  }
  ```

### 5. UI Integration
- [ ] Update Focus tab micronutrient section
- [ ] Add micronutrient breakdown to meal details
- [ ] Create visual indicators for deficiencies

### 6. Testing
- [ ] Test nutrient calculations
- [ ] Verify recommendation logic
- [ ] UI responsiveness testing

## Dependencies
- Food database API (which one?)
- NutritionSyncService
- Firebase for storage

## Questions
- Which food database API should we use?
- How detailed should micronutrient tracking be?
- Should we track all ~30 nutrients or focus on key ones?