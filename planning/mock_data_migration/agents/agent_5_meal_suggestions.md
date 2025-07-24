# Agent 5: Meal Suggestions Migration

## Objective
Replace hardcoded meal suggestions in WindowNutritionCalculator with AI-powered, personalized meal recommendations.

## Current State
- `generateSmartSuggestions()` returns 3 hardcoded meals:
  - "Grilled Chicken Salad" (350 cal, 30g protein, 20g carbs, 15g fat)
  - "Quinoa Buddha Bowl" (450 cal, 15g protein, 60g carbs, 18g fat)
  - "Greek Yogurt with Berries" (180 cal, 20g protein, 25g carbs, 3g fat)
- Basic logic checks remaining macros but suggestions are static
- No personalization or variety

## Target State
- AI-generated suggestions based on:
  - User's remaining macros for the window
  - Previous meal preferences
  - Dietary restrictions/preferences
  - Goal optimization (energy, sleep, etc.)
  - Time of day and meal window type
- Real food database integration
- Dynamic, varied suggestions

## Tasks

### 1. Food Database Integration
- [ ] Select and integrate food API (Nutritionix, USDA, etc.)
- [ ] Create FoodDatabaseService
- [ ] Implement food search functionality
- [ ] Cache common foods locally

### 2. AI Suggestion Engine
- [ ] Design Gemini prompts for meal suggestions
- [ ] Create prompt that considers:
  ```swift
  let suggestionPrompt = """
  Generate 3-5 meal suggestions for user:
  
  WINDOW: \(window.name) at \(window.timeRange)
  REMAINING MACROS: 
  - Calories: \(remaining.calories)
  - Protein: \(remaining.protein)g
  - Carbs: \(remaining.carbs)g
  - Fat: \(remaining.fat)g
  
  USER CONTEXT:
  - Goal: \(user.primaryGoal)
  - Recent meals: \(recentMeals)
  - Preferences: \(dietaryPreferences)
  - Micronutrient needs: \(topNeededNutrients)
  
  Suggest meals that:
  1. Fit within remaining macros
  2. Support their \(primaryGoal)
  3. Address micronutrient needs
  4. Are appropriate for \(window.name) time
  5. Provide variety from recent meals
  """
  ```

### 3. Update WindowNutritionCalculator
- [ ] Remove hardcoded suggestions
- [ ] Integrate with AI service:
  ```swift
  func generateSmartSuggestions(
      for window: MealWindow,
      remainingNutrition: NutritionGoals,
      userContext: UserContext
  ) async -> [MealSuggestion] {
      // Call AI service with context
      let suggestions = await aiService.generateMealSuggestions(
          window: window,
          remaining: remainingNutrition,
          context: userContext
      )
      
      // Validate suggestions fit macros
      return suggestions.filter { suggestion in
          suggestion.nutrition.fitsWithin(remainingNutrition)
      }
  }
  ```

### 4. Caching & Performance
- [ ] Cache AI suggestions for 2-4 hours
- [ ] Pre-generate suggestions for upcoming windows
- [ ] Handle offline mode gracefully
- [ ] Implement fallback to expanded food database search

### 5. User Preference Learning
- [ ] Track which suggestions users actually eat
- [ ] Learn meal preferences over time
- [ ] Adjust future suggestions based on history
- [ ] Consider meal prep preferences

### 6. Testing
- [ ] Test variety of suggestions
- [ ] Verify macro accuracy
- [ ] Test edge cases (very low remaining calories, etc.)
- [ ] Performance testing with AI calls

## Dependencies
- Food database API selection
- GeminiService for AI suggestions
- User preference storage
- Caching strategy

## Questions
- Should we pre-populate with common meals for faster response?
- How many suggestions to show (3-5)?
- Should suggestions include recipes or just meal names?
- Do we need restaurant options as well as home-cooked meals?

## Priority
**HIGH** - This directly impacts user experience in the Focus tab and is currently showing obvious mock data.