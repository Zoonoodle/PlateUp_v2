# Morning Check-In Implementation Plan

## Overview
The morning check-in is a critical feature that sets up the user's entire day by generating personalized meal windows based on their wake time, goals, and preferences. Currently, the check-in UI exists but isn't connected to the window generation system.

## Current State Analysis

### What's Working:
- ✅ UI for morning check-in exists in `MorningCheckInView.swift`
- ✅ Basic data collection (wake time, sleep quality, today's goals)
- ✅ Firebase storage structure exists

### What's Missing:
- ❌ Window generation based on check-in data
- ❌ Timing explanations for why windows are placed when they are
- ❌ Goal adaptation (how windows adjust for specific goals)
- ❌ Clear feedback on what's being stored and calculated
- ❌ Connection between check-in and DailyNutritionService

## Detailed Implementation Requirements

### 1. Window Generation Logic

#### Input Data from Check-In:
```swift
struct MorningCheckInData {
    let wakeTime: Date
    let sleepQuality: SleepQuality // Poor, Fair, Good, Excellent
    let energyLevel: Int // 1-10
    let todaysGoals: [String] // Selected from user's goals
    let plannedActivities: [Activity] // Exercise, meetings, etc.
    let stressLevel: Int // 1-10
}
```

#### Window Generation Algorithm:
```swift
func generateWindows(from checkIn: MorningCheckInData) -> [MealWindow] {
    // Base timing calculations
    let breakfastTime = wakeTime + 30-90 minutes (based on goals)
    let lunchTime = breakfastTime + 4-5 hours
    let dinnerTime = lunchTime + 4-6 hours
    
    // Adjustments based on:
    - Sleep quality (poor sleep = later breakfast)
    - Energy level (low energy = earlier breakfast)
    - Goals (weight loss = longer fasting, energy = frequent meals)
    - Activities (pre-workout window if exercise planned)
}
```

### 2. Timing Explanations

Each window should include WHY it's placed at that time:

```swift
struct WindowExplanation {
    let window: MealWindow
    let reasoning: [String] // Multiple reasons
    let goalAlignment: String // How this timing helps their goal
    let scientificBasis: String // Brief science explanation
}

// Example:
"Breakfast at 7:30 AM because:
- You woke at 6:30 AM - eating within 1 hour supports metabolism
- Your 'Improve Energy' goal benefits from early fuel
- Low morning energy (4/10) suggests you need nutrients soon
- Based on circadian rhythm research for optimal cortisol response"
```

### 3. Goal-Specific Adaptations

#### Weight Loss Goals:
- Extended morning fasting window (90+ min after wake)
- Smaller breakfast window
- Earlier dinner to extend overnight fast
- Lower calorie targets

#### Energy Improvement Goals:
- Earlier breakfast (30-45 min after wake)
- More frequent, smaller windows
- Strategic carb timing
- Pre/post activity fueling

#### Muscle Building Goals:
- Protein-focused windows
- Post-workout window timing
- More frequent feeding
- Higher calorie targets

#### Sleep Quality Goals:
- Earlier dinner window
- No eating 3 hours before bed
- Lighter evening meals
- Specific nutrients for sleep

### 4. Data Storage Architecture

#### Firebase Structure:
```
users/
  {userId}/
    morningCheckIns/
      {date}/
        checkInData: {...}
        generatedPlan: {
          windows: [...],
          explanations: [...],
          adaptations: [...]
        }
        timestamp: ...
        
    dailyPlans/
      {date}/
        windows: [...] // Generated from morning check-in
        source: "morning_checkin" // vs "ai_generated" or "manual"
        checkInId: {reference to morning check-in}
```

### 5. User Feedback & Transparency

#### During Check-In:
- Real-time preview of window timing as user inputs data
- Explanations appear as user makes selections
- "Why we're asking" tooltips for each question

#### After Check-In:
- Summary screen showing:
  - Generated windows with times
  - Key adaptations made for their goals
  - What data influenced each decision
  - Option to adjust if needed

#### In Daily Use:
- Windows show their "origin story" when tapped
- Reminders include personalized reasoning
- Progress tracking shows if timing is working

## Implementation Steps

### Phase 1: Connect Check-In to Window Generation
1. Create `WindowGenerationService`
2. Implement basic timing algorithm
3. Connect to `DailyNutritionService`
4. Store generated windows in Firebase

### Phase 2: Add Intelligence
1. Goal-specific timing rules
2. Activity-based adjustments
3. Sleep quality adaptations
4. Energy level considerations

### Phase 3: Explanations & Transparency
1. Generate explanations for each window
2. Create explanation UI components
3. Add "why" tooltips throughout
4. Implement feedback collection

### Phase 4: Refinement
1. A/B test different timing strategies
2. Collect user satisfaction data
3. Refine algorithms based on outcomes
4. Add machine learning for personalization

## Technical Components Needed

### New Services:
- `WindowGenerationService` - Core generation logic
- `WindowExplanationService` - Creates user-friendly explanations
- `GoalAdaptationService` - Applies goal-specific rules

### UI Components:
- `WindowTimingPreview` - Shows real-time preview during check-in
- `WindowExplanationCard` - Displays reasoning for each window
- `CheckInSummaryView` - Post check-in results screen

### Data Models:
- `WindowGenerationContext` - All factors used in generation
- `WindowExplanation` - Reasoning and science
- `GoalAdaptation` - How windows adapt to goals

## Success Metrics

1. **User Understanding**: 90%+ users understand why their windows are timed as they are
2. **Goal Alignment**: Windows demonstrably support user goals (tracked via progress)
3. **Adherence**: 80%+ users stick to generated windows
4. **Satisfaction**: 4.5+ star rating on window timing

## Next Steps

1. Review and refine this plan
2. Create `WindowGenerationService` with basic algorithm
3. Update `MorningCheckInView` to call generation service
4. Add explanation generation
5. Implement UI to show explanations
6. Test with various user scenarios
7. Iterate based on feedback