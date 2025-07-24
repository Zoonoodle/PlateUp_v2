# Agent 3: AI Coaching & Smart Content

## Objective
Replace static AI coaching messages with real pattern-based insights and dynamic content generation.

## Current State
- AICoachingInsightsViewV2 shows hard-coded messages
- DashboardViewModel.generateSmartContent() returns time-based static content
- No real pattern analysis or personalization

## Target State
- AI-generated insights based on actual user data
- Pattern recognition across meals, energy, and sleep
- Contextual recommendations from Gemini AI

## Tasks

### 1. Pattern Analysis Service
- [ ] Create PatternAnalysisService
- [ ] Implement pattern detection:
  - Meal timing vs energy correlations
  - Food choices vs sleep quality
  - Nutrient intake vs performance
  - Weekly/monthly trends

### 2. AI Coaching Service Enhancement
- [ ] Remove static insight messages
- [ ] Implement generateInsights() with real data:
  ```swift
  func generateInsights() async -> [CoachingInsight] {
      let patterns = await patternAnalysis.analyzeLastWeek()
      let prompt = buildInsightPrompt(patterns: patterns)
      return await geminiService.generateInsights(prompt)
  }
  ```

### 3. Smart Content Generation
- [ ] Replace static generateSmartContent()
- [ ] Create context-aware content:
  - Current nutrition status
  - Time of day + meal windows
  - Recent patterns
  - Goal progress

### 4. Gemini Integration
- [ ] Design insight generation prompts
- [ ] Implement caching for AI responses
- [ ] Handle rate limiting gracefully
- [ ] Create fallback for offline mode

### 5. Insight Types
- [ ] Energy optimization insights
- [ ] Sleep quality correlations
- [ ] Meal timing recommendations
- [ ] Micronutrient insights
- [ ] Goal-specific coaching

### 6. Testing
- [ ] Mock pattern data for testing
- [ ] Verify AI response quality
- [ ] Test caching and offline behavior

## Dependencies
- GeminiService
- PatternAnalysisService (new)
- Historical user data
- Firebase for caching

## Questions
- How often should insights be regenerated?
- Should we cache AI responses? For how long?
- What's the fallback for API failures?