# /test-coaching - AI Coaching Validation

## Purpose
Test and validate the AI coaching system with mock user data to ensure quality, accuracy, and personalization.

## Workflow

1. **Load Test Scenarios**
   - Different user profiles (weight loss, muscle gain, energy optimization)
   - Various meal patterns and timing
   - Edge cases and error conditions

2. **Run Coaching Analysis**
   - Execute AI coaching for each scenario
   - Measure response time and quality
   - Check for personalization accuracy

3. **Validate Responses**
   - Check for goal alignment
   - Verify specific recommendations
   - Ensure no hallucinations or generic advice

4. **Generate Report**
   - Success rate
   - Average response time
   - Quality metrics
   - Failed scenarios

## Test Implementation

```typescript
// Test scenarios structure
interface TestScenario {
  userId: string;
  profile: {
    name: string;
    primaryGoal: string;
    secondaryGoals: string[];
    constraints: string[];
  };
  recentMeals: Meal[];
  sleepData: SleepPattern[];
  energyLevels: EnergyData[];
  expectedInsights: string[];
}

// Run coaching tests
async function runCoachingTests() {
  const scenarios = [
    {
      // Scenario 1: Energy Optimization User
      userId: "test-energy-user",
      profile: {
        name: "Test User 1",
        primaryGoal: "Improve afternoon energy",
        secondaryGoals: ["Better sleep", "Stable mood"],
        constraints: ["Vegetarian", "Gluten-free"]
      },
      recentMeals: [
        { time: "12:30", foods: ["Large pasta salad", "Soda"], calories: 850 },
        { time: "08:00", foods: ["Coffee", "Bagel"], calories: 400 }
      ],
      sleepData: [
        { date: "2025-07-12", quality: 6, duration: 6.5 }
      ],
      energyLevels: [
        { time: "15:00", level: 3, notes: "Major crash" },
        { time: "10:00", level: 8, notes: "Good energy" }
      ],
      expectedInsights: [
        "Lunch timing correlation with energy crash",
        "High-carb lunch causing glucose spike",
        "Recommendation to eat lunch earlier",
        "Protein addition suggestion"
      ]
    },
    {
      // Scenario 2: Weight Loss User
      userId: "test-weight-loss",
      profile: {
        name: "Test User 2",
        primaryGoal: "Lose 20 pounds",
        secondaryGoals: ["Maintain muscle"],
        constraints: []
      },
      recentMeals: [
        { time: "20:00", foods: ["Pizza", "Beer"], calories: 1200 },
        { time: "14:00", foods: ["Salad", "Chicken"], calories: 450 }
      ],
      sleepData: [
        { date: "2025-07-12", quality: 5, duration: 6 }
      ],
      expectedInsights: [
        "Late dinner affecting sleep quality",
        "Evening calories too high for goal",
        "Suggestion for earlier dinner",
        "Calorie distribution recommendation"
      ]
    }
  ];

  // Run tests
  const results = [];
  for (const scenario of scenarios) {
    console.log(`\n🧪 Testing: ${scenario.profile.primaryGoal}`);
    
    const startTime = Date.now();
    const coachingResult = await runCoachingAnalysis(scenario);
    const duration = Date.now() - startTime;
    
    // Validate results
    const validation = validateCoachingResponse(
      coachingResult,
      scenario.expectedInsights
    );
    
    results.push({
      scenario: scenario.profile.primaryGoal,
      duration,
      success: validation.success,
      accuracy: validation.accuracy,
      issues: validation.issues
    });
  }
  
  // Generate report
  generateTestReport(results);
}

// Validation function
function validateCoachingResponse(response, expectedInsights) {
  let matchedInsights = 0;
  const issues = [];
  
  for (const expected of expectedInsights) {
    if (response.toLowerCase().includes(expected.toLowerCase())) {
      matchedInsights++;
    } else {
      issues.push(`Missing insight: ${expected}`);
    }
  }
  
  // Check for quality indicators
  if (response.length < 200) {
    issues.push("Response too short");
  }
  
  if (!response.includes("specific")) {
    issues.push("Lacks specific recommendations");
  }
  
  return {
    success: matchedInsights >= expectedInsights.length * 0.8,
    accuracy: matchedInsights / expectedInsights.length,
    issues
  };
}

// Report generation
function generateTestReport(results) {
  console.log("\n📊 Coaching Test Report");
  console.log("======================");
  
  const successRate = results.filter(r => r.success).length / results.length;
  const avgDuration = results.reduce((sum, r) => sum + r.duration, 0) / results.length;
  const avgAccuracy = results.reduce((sum, r) => sum + r.accuracy, 0) / results.length;
  
  console.log(`✅ Success Rate: ${(successRate * 100).toFixed(1)}%`);
  console.log(`⏱️ Avg Response Time: ${avgDuration}ms`);
  console.log(`🎯 Avg Accuracy: ${(avgAccuracy * 100).toFixed(1)}%`);
  
  // Failed scenarios
  const failed = results.filter(r => !r.success);
  if (failed.length > 0) {
    console.log("\n❌ Failed Scenarios:");
    failed.forEach(f => {
      console.log(`  - ${f.scenario}`);
      f.issues.forEach(issue => console.log(`    • ${issue}`));
    });
  }
}
```

## Quick Test Commands

```bash
# Run all coaching tests
npm run test:coaching

# Test specific scenario
npm run test:coaching -- --scenario="energy"

# Test with verbose output
npm run test:coaching -- --verbose

# Test with custom mock data
npm run test:coaching -- --data=./test-data/custom-scenarios.json
```

## Usage
Type `/test-coaching` to run the full AI coaching validation suite with mock data.