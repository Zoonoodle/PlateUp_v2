# Dynamic Meal Windows: Complete Solution Design

## Executive Summary

This document outlines a comprehensive, research-backed solution for PlateUp's meal timing system that adapts to user wake times, handles late-day app usage gracefully, and provides science-based nutrition distribution tailored to specific health goals. The system eliminates crashes from past window interactions while providing an intuitive, minimal user experience.

---

## 1. Science-Based Meal Timing & Distribution Research

### Research Findings on Optimal Meal Timing

#### Circadian Rhythm Alignment
- **Breakfast**: 1-2 hours after waking optimizes cortisol rhythm and metabolic activation
- **Lunch**: 4-5 hours after breakfast maintains stable blood glucose
- **Dinner**: 3-4 hours before sleep improves sleep quality and digestion
- **Window Duration**: 2-hour eating windows improve adherence without being restrictive

#### Goal-Specific Calorie Distribution Research

Based on scientific literature on meal timing and metabolic optimization:

```swift
enum NutritionGoal {
    case weightLoss
    case improveEnergy  
    case muscleGain
    case generalHealth
    
    var calorieDistribution: (breakfast: Double, lunch: Double, dinner: Double) {
        switch self {
        case .weightLoss:
            // Front-loaded distribution (research: Jakubowicz et al., 2013)
            // Larger breakfast improves satiety and reduces evening cravings
            return (0.40, 0.35, 0.25)
            
        case .improveEnergy:
            // Lunch-heavy for sustained afternoon performance
            // Based on chronobiology research for cognitive peak
            return (0.30, 0.40, 0.30)
            
        case .muscleGain:
            // Even distribution for consistent protein synthesis
            // Supports muscle protein synthesis throughout day
            return (0.30, 0.35, 0.35)
            
        case .generalHealth:
            // Traditional distribution following Mediterranean patterns
            return (0.25, 0.40, 0.35)
        }
    }
    
    var proteinTiming: String {
        switch self {
        case .muscleGain:
            return "20-30g per meal for optimal synthesis"
        case .weightLoss:
            return "Higher protein at breakfast (30-35g) for satiety"
        case .improveEnergy:
            return "Moderate protein, higher complex carbs at lunch"
        case .generalHealth:
            return "Balanced protein across all meals (20-25g)"
        }
    }
}
```

### Macronutrient Timing for Different Goals

#### Weight Loss
- **Morning**: High protein (35%), moderate carbs (35%), moderate fat (30%)
- **Lunch**: Balanced macros with emphasis on fiber
- **Dinner**: Lower carbs (25%), higher protein (40%), moderate fat (35%)
- **Rationale**: Front-loaded calories reduce evening hunger hormones

#### Energy Improvement
- **Morning**: Balanced with complex carbs for sustained energy
- **Lunch**: Higher carb ratio (45%) for afternoon cognitive performance
- **Dinner**: Lower carbs to avoid evening energy crashes
- **Rationale**: Aligns with natural cortisol and insulin sensitivity patterns

#### Muscle Gain
- **Even protein distribution**: 0.25-0.3g/kg body weight per meal
- **Post-workout window**: If training occurs, shift 10% more calories to post-workout meal
- **Carb timing**: Higher carbs around training windows

---

## 2. Dynamic Window Timing System

### Adaptive Timing Based on Wake Time

```swift
struct MealWindowTiming {
    let wakeTime: Date
    
    // Research-backed timing relative to wake
    var breakfastWindow: (start: Date, end: Date) {
        // Start 1.5 hours after wake (cortisol optimization)
        let start = wakeTime.addingTimeInterval(1.5 * 3600)
        let end = start.addingTimeInterval(2 * 3600)
        return (start, end)
    }
    
    var lunchWindow: (start: Date, end: Date) {
        // 4.5 hours after breakfast (glucose stability)
        let start = breakfastWindow.end.addingTimeInterval(2.5 * 3600)
        let end = start.addingTimeInterval(2 * 3600)
        return (start, end)
    }
    
    var dinnerWindow: (start: Date, end: Date) {
        // 4 hours after lunch, ending 3 hours before typical sleep
        let start = lunchWindow.end.addingTimeInterval(2 * 3600)
        let end = start.addingTimeInterval(2 * 3600)
        return (start, end)
    }
    
    // Validate windows don't extend too late
    func validateDinnerTiming(targetSleepTime: Date) -> Bool {
        let buffer = 3 * 3600 // 3 hours before sleep
        return dinnerWindow.end.addingTimeInterval(buffer) <= targetSleepTime
    }
}
```

---

## 3. Smart Check-In System (Window-Integrated)

### Morning Check-In (First App Open)

```swift
struct MorningCheckIn {
    // Wake time selection with intuitive intervals
    let wakeTimeOptions: [String] = [
        "Just now",
        "15 minutes ago",
        "30 minutes ago", 
        "45 minutes ago",
        "1 hour ago",
        "1.5 hours ago",
        "2 hours ago",
        "Earlier than 2 hours"
    ]
    
    // Sleep quality with emoji-based intuitive options
    enum SleepQuality: String, CaseIterable {
        case refreshed = "Refreshed & Ready 🌟"
        case decent = "Decent Rest 😊"
        case groggy = "Still Waking Up 😴"
        case poor = "Rough Night 😵"
        
        // Affects energy-related food suggestions
        var energyMultiplier: Double {
            switch self {
            case .refreshed: return 1.0
            case .decent: return 0.9
            case .groggy: return 0.8  // More B-vitamins, iron
            case .poor: return 0.7     // Emphasis on energy foods
            }
        }
        
        var nutritionFocus: [String] {
            switch self {
            case .refreshed: 
                return ["Maintain energy", "Balanced macros"]
            case .decent: 
                return ["Steady energy", "Regular portions"]
            case .groggy: 
                return ["B-vitamins", "Complex carbs", "Moderate caffeine"]
            case .poor: 
                return ["Easy digestion", "Iron-rich foods", "Hydration focus"]
            }
        }
    }
}
```

### Post-Meal Window Check-Ins

```swift
struct WindowCheckIn {
    let windowType: MealType
    let completionTime: Date
    
    // Energy assessment with visual/contextual options
    enum EnergyCheck: String, CaseIterable {
        case energized = "Energized & Focused ⚡"
        case steady = "Steady & Balanced 👍"
        case dipping = "Energy Dipping 📉"
        case crashed = "Energy Crashed 💤"
        
        func getCoachingInsight(for window: MealType) -> String {
            switch (self, window) {
            case (.crashed, .breakfast):
                return "Try adding more protein or reducing simple carbs"
            case (.crashed, .lunch):
                return "Your lunch may be too heavy - consider smaller portions"
            case (.dipping, _):
                return "Consider adding complex carbs or healthy fats"
            case (.energized, _):
                return "Great choice! This meal works well for you"
            default:
                return "Monitor how different foods affect your energy"
            }
        }
    }
    
    // Focus assessment
    enum FocusCheck: String, CaseIterable {
        case laser = "Laser Focused 🎯"
        case good = "Good Concentration 💡"
        case wandering = "Mind Wandering 🌊"
        case foggy = "Brain Fog 🌫️"
        
        var suggestsNutrientNeed: [String] {
            switch self {
            case .foggy: return ["Omega-3", "B12", "Iron"]
            case .wandering: return ["Complex carbs", "Magnesium"]
            default: return []
            }
        }
    }
}
```

---

## 4. Late-Day Loading Solution

### Dynamic Plan Generation

```swift
class DynamicNutritionService {
    
    func generateAdaptivePlan(wakeTime: Date? = nil) async -> DailyNutritionPlan {
        let currentTime = Date()
        let calendar = Calendar.current
        
        // Use provided wake time or estimate based on current time
        let estimatedWakeTime = wakeTime ?? estimateWakeTime(from: currentTime)
        
        // Calculate windows based on wake time
        let timing = MealWindowTiming(wakeTime: estimatedWakeTime)
        var windows: [MealWindow] = []
        
        // Only create windows that haven't ended yet
        if currentTime < timing.breakfastWindow.end {
            windows.append(createWindow(
                for: .breakfast,
                timing: timing.breakfastWindow,
                calorieRatio: getUserGoal().calorieDistribution.breakfast
            ))
        }
        
        if currentTime < timing.lunchWindow.end {
            windows.append(createWindow(
                for: .lunch,
                timing: timing.lunchWindow,
                calorieRatio: getUserGoal().calorieDistribution.lunch
            ))
        }
        
        if currentTime < timing.dinnerWindow.end {
            windows.append(createWindow(
                for: .dinner,
                timing: timing.dinnerWindow,
                calorieRatio: getUserGoal().calorieDistribution.dinner
            ))
        }
        
        // Special handling for very late users
        if windows.isEmpty {
            let eveningWindow = createAdaptiveEveningWindow(from: currentTime)
            windows.append(eveningWindow)
        }
        
        return DailyNutritionPlan(
            windows: windows,
            wakeTime: estimatedWakeTime,
            adaptedForLateStart: currentTime.hour >= 14
        )
    }
    
    private func createAdaptiveEveningWindow(from currentTime: Date) -> MealWindow {
        // For users starting after all regular windows
        let remainingCalories = calculateRemainingDailyCalories()
        
        return MealWindow(
            name: "Evening Nutrition",
            startTime: currentTime,
            endTime: currentTime.addingTimeInterval(3 * 3600), // 3 hour window
            targetCalories: min(remainingCalories, 600), // Cap at 600 for late eating
            targetMacros: Macros(
                protein: 30, // Higher protein for satiety
                carbs: 40,   // Moderate carbs to avoid sleep disruption  
                fat: 20,     // Moderate fat for satisfaction
                fiber: 10
            ),
            reasoning: "Late-day nutrition focused on satiety without disrupting sleep"
        )
    }
}
```

---

## 5. Missed Window Handling System

### Research-Based Compensation Strategy

Based on research on meal skipping and metabolic adaptation:

```swift
struct MissedWindowHandler {
    
    enum MissedWindowAction {
        case ateButForgotToLog(estimatedTime: Date)
        case didntEat
        case ateOutsideWindow(actualTime: Date)
    }
    
    func handleMissedWindow(_ window: MealWindow, action: MissedWindowAction) -> CompensationPlan {
        switch action {
        case .ateButForgotToLog(let time):
            // Allow retroactive logging with timestamp
            return .logPastMeal(window: window, time: time)
            
        case .didntEat:
            // Research shows 60-70% compensation prevents overeating
            // (Levitsky & DeRosimo, 2010)
            let missedCalories = window.targetCalories
            let compensationAmount = missedCalories * 0.65
            
            // Smart distribution based on remaining windows
            let distribution = calculateOptimalRedistribution(
                calories: compensationAmount,
                remainingWindows: getRemainingWindows(),
                userGoal: getUserGoal()
            )
            
            return .redistributeCalories(
                distribution: distribution,
                reason: "Skipped \(window.name) - redistributing 65% to prevent overeating"
            )
            
        case .ateOutsideWindow(let actualTime):
            // Log with actual time and adjust future windows
            let timeDifference = actualTime.timeIntervalSince(window.startTime)
            
            if abs(timeDifference) < 3600 { // Within 1 hour
                return .logWithMinorTimeVariance(window: window, actualTime: actualTime)
            } else {
                return .logWithMajorTimeVariance(
                    window: window,
                    actualTime: actualTime,
                    adjustFutureWindows: true
                )
            }
        }
    }
    
    private func calculateOptimalRedistribution(
        calories: Double,
        remainingWindows: [MealWindow],
        userGoal: NutritionGoal
    ) -> [WindowID: Double] {
        
        var distribution: [WindowID: Double] = [:]
        
        switch remainingWindows.count {
        case 0:
            // No windows left, don't compensate
            return [:]
            
        case 1:
            // All to remaining window (capped at +40% original)
            let window = remainingWindows[0]
            let maxAddition = window.targetCalories * 0.4
            distribution[window.id] = min(calories, maxAddition)
            
        case 2:
            // Split based on goal
            if userGoal == .weightLoss {
                // Front-load compensation
                distribution[remainingWindows[0].id] = calories * 0.6
                distribution[remainingWindows[1].id] = calories * 0.4
            } else {
                // Even split
                distribution[remainingWindows[0].id] = calories * 0.5
                distribution[remainingWindows[1].id] = calories * 0.5
            }
            
        default:
            // Distribute evenly across remaining windows
            let perWindow = calories / Double(remainingWindows.count)
            remainingWindows.forEach { window in
                distribution[window.id] = perWindow
            }
        }
        
        return distribution
    }
}
```

---

## 6. Complete User Flow Implementation

### Day Lifecycle Manager

```swift
class DayLifecycleManager: ObservableObject {
    @Published var dayStarted = false
    @Published var wakeTime: Date?
    @Published var sleepQuality: MorningCheckIn.SleepQuality?
    @Published var currentPlan: DailyNutritionPlan?
    @Published var missedWindows: [MealWindow] = []
    
    // Local storage for offline capability
    @AppStorage("dayStartedFlag") private var storedDayStarted = false
    @AppStorage("lastWakeTime") private var storedWakeTime: Double = 0
    @AppStorage("currentDayDate") private var storedDayDate: String = ""
    
    func startDay(wakeTime: Date, sleepQuality: MorningCheckIn.SleepQuality) async {
        self.wakeTime = wakeTime
        self.sleepQuality = sleepQuality
        self.dayStarted = true
        
        // Store locally
        storedDayStarted = true
        storedWakeTime = wakeTime.timeIntervalSince1970
        storedDayDate = DateFormatter.yyyyMMdd.string(from: Date())
        
        // Generate adaptive plan based on wake time and sleep quality
        let nutritionService = DynamicNutritionService()
        nutritionService.adjustForSleepQuality(sleepQuality)
        
        currentPlan = await nutritionService.generateAdaptivePlan(wakeTime: wakeTime)
        
        // Save to Firebase
        await saveCheckInData()
        
        // Schedule window notifications
        scheduleWindowReminders()
    }
    
    func checkForMissedWindows() -> [MealWindow] {
        guard let plan = currentPlan else { return [] }
        let now = Date()
        
        return plan.mealWindows.filter { window in
            window.endTime < now && !window.isCompleted && window.loggedMeals.isEmpty
        }
    }
    
    func handleMissedWindow(_ window: MealWindow, action: MissedWindowHandler.MissedWindowAction) async {
        let handler = MissedWindowHandler()
        let compensation = handler.handleMissedWindow(window, action: action)
        
        // Apply compensation plan
        await applyCompensation(compensation)
        
        // Update UI
        objectWillChange.send()
    }
    
    // Reset at midnight or on new day
    func checkDayReset() {
        let currentDate = DateFormatter.yyyyMMdd.string(from: Date())
        if currentDate != storedDayDate {
            resetDay()
        }
    }
    
    private func resetDay() {
        dayStarted = false
        wakeTime = nil
        sleepQuality = nil
        currentPlan = nil
        missedWindows = []
        storedDayStarted = false
    }
}
```

---

## 7. UI Flow & Experience

### Focus Tab Implementation

```swift
struct FocusTabView: View {
    @StateObject private var dayManager = DayLifecycleManager()
    @State private var showMissedWindowSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !dayManager.dayStarted {
                    // Morning check-in card
                    MorningCheckInCard { wakeTime, sleepQuality in
                        Task {
                            await dayManager.startDay(
                                wakeTime: wakeTime,
                                sleepQuality: sleepQuality
                            )
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                    
                } else if let plan = dayManager.currentPlan {
                    // Daily overview (collapsible)
                    DailyNutritionOverviewCard(plan: plan)
                    
                    // Current/Active window (auto-expanded)
                    if let activeWindow = plan.currentWindow {
                        ActiveMealWindowCard(
                            window: activeWindow,
                            onFoodLogged: { food in
                                await logFoodToWindow(food, window: activeWindow)
                                // Trigger 2-second check-in after logging
                                showQuickCheckIn(for: activeWindow)
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.plateUpGreen, lineWidth: 2)
                        )
                    }
                    
                    // Upcoming windows (collapsed by default)
                    if !plan.upcomingWindows.isEmpty {
                        UpcomingWindowsSection(
                            windows: plan.upcomingWindows,
                            isExpanded: false
                        )
                    }
                    
                    // Missed windows handling
                    let missed = dayManager.checkForMissedWindows()
                    if !missed.isEmpty {
                        MissedWindowsCard(count: missed.count)
                            .onTapGesture {
                                showMissedWindowSheet = true
                            }
                    }
                    
                    // Late day guidance
                    if plan.adaptedForLateStart {
                        LateStartGuidanceCard()
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showMissedWindowSheet) {
            MissedWindowHandlingSheet(
                missedWindows: dayManager.checkForMissedWindows(),
                onAction: { window, action in
                    await dayManager.handleMissedWindow(window, action: action)
                    showMissedWindowSheet = false
                }
            )
        }
        .onAppear {
            dayManager.checkDayReset()
        }
    }
}
```

### Quick Post-Meal Check-In

```swift
struct QuickCheckInView: View {
    let window: MealWindow
    @State private var energyLevel: WindowCheckIn.EnergyCheck?
    @State private var focusLevel: WindowCheckIn.FocusCheck?
    let onComplete: (WindowCheckIn) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Check-in")
                .font(.headline)
            
            Text("How's your energy?")
                .font(.subheadline)
            
            // Visual energy options
            HStack(spacing: 12) {
                ForEach(WindowCheckIn.EnergyCheck.allCases, id: \.self) { level in
                    Button(action: { energyLevel = level }) {
                        VStack {
                            Text(level.emoji)
                                .font(.largeTitle)
                            Text(level.shortLabel)
                                .font(.caption2)
                        }
                        .padding()
                        .background(
                            energyLevel == level ? 
                            Color.plateUpGreen.opacity(0.2) : 
                            Color.gray.opacity(0.1)
                        )
                        .cornerRadius(12)
                    }
                }
            }
            
            if energyLevel != nil {
                Text("How's your focus?")
                    .font(.subheadline)
                    .transition(.opacity)
                
                // Visual focus options
                HStack(spacing: 12) {
                    ForEach(WindowCheckIn.FocusCheck.allCases, id: \.self) { level in
                        Button(action: { 
                            focusLevel = level
                            completeCheckIn()
                        }) {
                            VStack {
                                Text(level.emoji)
                                    .font(.largeTitle)
                                Text(level.shortLabel)
                                    .font(.caption2)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .cornerRadius(20)
    }
    
    private func completeCheckIn() {
        guard let energy = energyLevel, let focus = focusLevel else { return }
        
        let checkIn = WindowCheckIn(
            windowType: window.type,
            completionTime: Date(),
            energy: energy,
            focus: focus
        )
        
        // Haptic feedback
        HapticManager.impact(.medium)
        
        // Dismiss after slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onComplete(checkIn)
        }
    }
}
```

---

## 8. Implementation Guidelines - NEW FILE CREATION STRATEGY

### CRITICAL: File Organization for New Features

**IMPORTANT: Create NEW files for all new features to maintain clean separation and easy rollback**

```yaml
New File Creation Rules:
  1. Check-In System:
     - Create: Views/CheckIns/MorningCheckInCard.swift
     - Create: Views/CheckIns/QuickPostMealCheckIn.swift
     - Create: Views/CheckIns/WindowCheckInModels.swift
     - DELETE after implementation: Any old check-in views
  
  2. Meal Window System:
     - Create: Views/MealWindows/DynamicMealWindowCard.swift
     - Create: Views/MealWindows/ActiveWindowCard.swift
     - Create: Views/MealWindows/MissedWindowSheet.swift
     - Create: Services/DynamicNutritionService.swift
     - DELETE after implementation: Old static meal window views
  
  3. Mandatory Pop-ups:
     - Create: Views/Popups/MorningStartDayPopup.swift
     - Create: Views/Popups/MissedWindowHandlingPopup.swift
     - Create: Views/Popups/QuickCheckInPopup.swift
     - DELETE after implementation: Any conflicting popup views
  
  4. Focus Tab Redesign:
     - Create: Views/Focus/NewFocusTabView.swift
     - Create: Views/Focus/DayLifecycleManager.swift
     - DELETE after implementation: Old FocusTabView.swift
```

### File Deletion Strategy
```swift
// After new implementation is tested and working:
1. Comment out old file imports
2. Test app thoroughly
3. Delete old files permanently
4. Clean up any remaining references
```

---

## 9. UI Mockups & Visual Specifications

### Morning Check-In Card Mockup
```
┌─────────────────────────────────────┐
│  Good Morning! 🌅                   │
│                                     │
│  When did you wake up?              │
│  ┌─────────────────────────────┐    │
│  │ ⏰ Just now                 │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ⏰ 30 minutes ago          │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ⏰ 1 hour ago              │    │
│  └─────────────────────────────┘    │
│                                     │
│  How did you sleep?                 │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐  │
│  │ 🌟 │ │ 😊 │ │ 😴 │ │ 😵 │  │
│  └─────┘ └─────┘ └─────┘ └─────┘  │
│                                     │
│  [    Start Your Day    ]           │
│                                     │
└─────────────────────────────────────┘

Visual Specs:
- Background: Black with white.opacity(0.03)
- Corner radius: 20px
- Padding: 24px
- Button height: 56px
- Emoji buttons: 64x64px
- Primary button: Green accent
- Appears as full-screen overlay on first open
```

### Active Meal Window Card Mockup
```
┌─────────────────────────────────────┐
│ 🍽️ Lunch Window    • 2h 15m left   │
│ ─────────────────────────────────── │
│                                     │
│ Remaining Nutrition:                │
│ 425 cal | 28g protein | 45g carbs  │
│                                     │
│ ▓▓▓▓▓▓▓▓▓░░░░░░  425/850 cal      │
│ ▓▓▓▓▓▓░░░░░░░░░  28/45g protein   │
│ ▓▓▓▓▓▓▓▓░░░░░░░  32/45g carbs     │
│                                     │
│ 💡 Suggestions that fit:            │
│ ┌─────────────────────────────┐    │
│ │ Grilled Chicken Salad       │    │
│ │ 380 cal • 35g protein       │    │
│ └─────────────────────────────┘    │
│ ┌─────────────────────────────┐    │
│ │ Quinoa Buddha Bowl          │    │
│ │ 420 cal • 18g protein       │    │
│ └─────────────────────────────┘    │
│                                     │
│ [+] Log Food to This Window         │
│                                     │
└─────────────────────────────────────┘

Visual Specs:
- Green border: 2px when active
- Progress bars: Green fill, gray background
- Calorie text: Bold, size 18
- Time remaining: Pulsing animation
- Auto-expands when window is active
```

### Quick Post-Meal Check-In Popup Mockup
```
┌─────────────────────────────────────┐
│         Quick Check-in ⚡           │
│                                     │
│     How's your energy?              │
│                                     │
│   ⚡      👍      📉      💤       │
│ Energized Steady  Dipping Crashed   │
│                                     │
│     How's your focus?               │
│                                     │
│   🎯      💡      🌊      🌫️      │
│  Laser   Good   Wandering  Foggy    │
│                                     │
└─────────────────────────────────────┘

Visual Specs:
- Appears 2 seconds after food logging
- Semi-transparent background overlay
- Spring animation entrance
- Auto-dismisses after selection
- Size: 320x280px centered
- Corner radius: 24px
- Haptic feedback on selection
```

### Missed Window Handling Sheet Mockup
```
┌─────────────────────────────────────┐
│ Missed Meal Windows                 │
│ ─────────────────────────────────── │
│                                     │
│ 🍳 Breakfast (8:00 AM - 10:00 AM)  │
│ ┌─────────────────────────────┐    │
│ │ ✓ I ate but forgot to log   │    │
│ └─────────────────────────────┘    │
│ ┌─────────────────────────────┐    │
│ │ ⏭️ I skipped this meal      │    │
│ └─────────────────────────────┘    │
│ ┌─────────────────────────────┐    │
│ │ 🕐 I ate at a different time│    │
│ └─────────────────────────────┘    │
│                                     │
│ What happens next:                  │
│ • Skipped meals: We'll redistribute │
│   65% of calories to later windows  │
│ • Different time: Log with actual   │
│   time for better future planning   │
│                                     │
└─────────────────────────────────────┘

Visual Specs:
- Bottom sheet presentation
- Height: 60% of screen
- Swipe down to dismiss
- Option buttons: 48px height
- Explanatory text: opacity 0.7
```

### Late Day Guidance Card Mockup
```
┌─────────────────────────────────────┐
│ 🌙 Evening Nutrition Plan           │
│                                     │
│ Since you're starting late today,   │
│ we've created a single nutrition    │
│ window optimized for evening eating │
│                                     │
│ Your Evening Window (6pm - 9pm):    │
│ • 600 calories maximum              │
│ • Higher protein for satiety        │
│ • Lower carbs for better sleep      │
│                                     │
│ Tomorrow we'll start fresh with     │
│ your personalized meal timing! 🌟   │
│                                     │
└─────────────────────────────────────┘

Visual Specs:
- Soft gradient background
- Moon emoji with subtle glow
- Appears only for late-day starts
- Encouraging, non-judgmental tone
```

### Focus Tab Layout Mockup (Consolidated)
```
┌─────────────────────────────────────┐
│ Focus                               │
│ ═══════════════════════════════════ │
│                                     │
│ ┌─────────────────────────────┐    │
│ │ Daily Nutrition Overview ▼   │    │
│ │ 78% Complete • 425 cal left │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─────────────────────────────┐    │
│ │ 🟢 Lunch Window - ACTIVE    │    │
│ │ Detailed nutrition info...   │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─────────────────────────────┐    │
│ │ Upcoming Windows ▶           │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─────────────────────────────┐    │
│ │ Check-ins (2/4) ▶           │    │
│ └─────────────────────────────┘    │
│                                     │
│ ┌─────────────────────────────┐    │
│ │ AI Insights 💡               │    │
│ │ Your protein timing today    │    │
│ │ improved focus by 23%        │    │
│ └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘

Visual Specs:
- All cards customizable position
- Collapsible sections save state
- Active window auto-expands
- Green accent: 10-20% only
- Smooth spring animations
```

---

## 10. Fix for Current Crash

### Immediate Crash Prevention (Without AI Dependency)

Since the system no longer relies on AI API requests for meal window generation, the crash issues related to API parsing are eliminated. However, we still need to handle late-day loading scenarios gracefully:

```swift
extension DailyNutritionService {
    
    func generateLocalPlan() {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        
        // Create windows based on current time
        var windows: [MealWindow] = []
        
        // Define standard window times
        let standardWindows = [
            (name: "Breakfast", start: 7, end: 10),
            (name: "Lunch", start: 12, end: 14),
            (name: "Dinner", start: 18, end: 20)
        ]
        
        // Only create windows that are relevant (not completely passed)
        for window in standardWindows {
            let windowEndHour = window.end
            
            // Skip if window has completely passed
            if hour > windowEndHour {
                continue
            }
            
            // Create window with appropriate status
            let startTime = calendar.date(bySettingHour: window.start, minute: 0, second: 0, of: now)!
            let endTime = calendar.date(bySettingHour: window.end, minute: 0, second: 0, of: now)!
            
            let mealWindow = MealWindow(
                name: window.name,
                startTime: startTime,
                endTime: endTime,
                status: determineWindowStatus(now: now, start: startTime, end: endTime),
                targetCalories: calculateWindowCalories(for: window.name),
                targetMacros: calculateWindowMacros(for: window.name)
            )
            
            windows.append(mealWindow)
        }
        
        // If no windows remain (very late start), create evening window
        if windows.isEmpty {
            windows.append(createEveningWindow(from: now))
        }
        
        // Update UI safely
        DispatchQueue.main.async { [weak self] in
            self?.dailyPlan = DailyNutritionPlan(
                date: now,
                userId: self?.userId ?? "",
                mealWindows: windows
            )
            self?.isLoading = false
        }
    }
    
    private func determineWindowStatus(now: Date, start: Date, end: Date) -> WindowStatus {
        if now < start {
            return .upcoming
        } else if now >= start && now <= end {
            return .active
        } else {
            return .past
        }
    }
    
    // Safe window interaction without AI dependency
    func handleWindowTap(_ window: MealWindow) {
        switch window.status {
        case .past:
            // Show missed window options
            presentMissedWindowSheet(for: window)
        case .active:
            // Navigate to active window detail
            navigateToActiveWindow(window)
        case .upcoming:
            // Show preview of upcoming window
            showUpcomingWindowPreview(window)
        }
    }
}
```

---

## 11. Implementation Priorities

### Phase 1: Core Infrastructure (Days 1-3)
1. Create new file structure as specified in Section 8
2. Implement `DayLifecycleManager` in new file
3. Add morning check-in flow with new UI components
4. Fix crash with local plan generation (no AI dependency)

### Phase 2: Dynamic Windows (Days 4-6)
1. Implement wake-time-based window calculation
2. Add goal-specific calorie distribution
3. Create missed window compensation logic
4. Build quick check-in UI with mockup specifications

### Phase 3: Polish & Intelligence (Days 7-10)
1. Add coaching insights based on check-ins
2. Implement smart food suggestions
3. Create late-day user experience
4. Add haptic feedback and animations
5. Delete old files after verification

---

## 12. Success Metrics

### Technical Success
- Zero crashes from window interactions
- All windows properly time-gated
- Smooth late-day experience
- Check-in completion rate >80%

### User Experience Success
- Morning check-in completion >90%
- Reduced confusion for late-day users
- Positive feedback on adaptive windows
- Increased meal logging accuracy

### Business Success
- Improved retention for users with irregular schedules
- Higher engagement with personalized timing
- Reduced support tickets about crashes
- Better goal achievement rates

---

## Conclusion

This comprehensive solution transforms PlateUp's meal window system from a rigid, crash-prone structure to an intelligent, adaptive system that works with users' natural rhythms and schedules. By grounding all timing decisions in nutritional science and user behavior research, we create a system that not only prevents crashes but actively improves user outcomes through personalized, goal-oriented nutrition timing.
