# /coordinate-agents - Multi-Agent Task Distribution

## Purpose
Intelligently distribute work between Frontend, Backend, AI, and QA agents to maximize parallel development efficiency.

## Workflow

1. **Analyze Task Requirements**
   - Parse user request
   - Identify components needed
   - Determine dependencies
   
2. **Create Agent Task Breakdown**
   - Frontend tasks (UI/UX)
   - Backend tasks (Firebase/API)
   - AI tasks (Gemini/coaching)
   - QA tasks (testing/monitoring)
   
3. **Generate Parallel Execution Plan**
   - Independent tasks that can run simultaneously
   - Dependent tasks with clear sequencing
   - Coordination points
   
4. **Output Agent Commands**
   - Ready-to-execute commands for each agent
   - Clear task descriptions
   - Expected deliverables

## Task Distribution Logic

```typescript
interface AgentTask {
  agent: 'frontend' | 'backend' | 'ai' | 'qa';
  priority: 'high' | 'medium' | 'low';
  dependencies: string[];
  description: string;
  deliverables: string[];
  estimatedTime: string;
}

interface FeatureRequest {
  name: string;
  description: string;
  userStory: string;
  acceptanceCriteria: string[];
}

function distributeFeatureTasks(feature: FeatureRequest): AgentTask[] {
  const tasks: AgentTask[] = [];
  
  // Analyze feature requirements
  const analysis = analyzeFeature(feature);
  
  // Frontend Tasks
  if (analysis.requiresUI) {
    tasks.push({
      agent: 'frontend',
      priority: 'high',
      dependencies: [],
      description: `Create SwiftUI views for ${feature.name}`,
      deliverables: [
        'SwiftUI view components',
        'ViewModels with @Observable',
        'Accessibility implementation',
        'Design system integration'
      ],
      estimatedTime: analysis.uiComplexity === 'high' ? '4-6 hours' : '2-3 hours'
    });
  }
  
  // Backend Tasks
  if (analysis.requiresBackend) {
    tasks.push({
      agent: 'backend',
      priority: 'high',
      dependencies: [],
      description: `Implement Firebase services for ${feature.name}`,
      deliverables: [
        'Firestore schema updates',
        'Cloud Functions implementation',
        'Security rules',
        'API endpoints'
      ],
      estimatedTime: analysis.backendComplexity === 'high' ? '3-4 hours' : '1-2 hours'
    });
  }
  
  // AI Tasks
  if (analysis.requiresAI) {
    tasks.push({
      agent: 'ai',
      priority: analysis.aiCritical ? 'high' : 'medium',
      dependencies: ['backend-data-schema'],
      description: `Develop AI coaching for ${feature.name}`,
      deliverables: [
        'Gemini prompt engineering',
        'Coaching algorithm',
        'Clarification questions',
        'Response validation'
      ],
      estimatedTime: '2-3 hours'
    });
  }
  
  // QA Tasks
  tasks.push({
    agent: 'qa',
    priority: 'medium',
    dependencies: ['frontend-complete', 'backend-complete'],
    description: `Test and validate ${feature.name}`,
    deliverables: [
      'Unit tests',
      'Integration tests',
      'Performance benchmarks',
      'Error scenarios'
    ],
    estimatedTime: '2 hours'
  });
  
  return tasks;
}
```

## Example Task Distributions

### Feature: "Smart Meal Recommendations"
```yaml
Frontend_Agent:
  Tasks:
    - Create MealRecommendationView with SwiftUI 6
    - Implement recommendation cards with animations
    - Add filtering UI for dietary preferences
    - Integrate with existing meal logging flow
  Dependencies: None
  Can Start: Immediately

Backend_Agent:
  Tasks:
    - Design Firestore schema for recommendations
    - Create Cloud Function for recommendation generation
    - Implement caching for performance
    - Add analytics tracking
  Dependencies: None
  Can Start: Immediately

AI_Agent:
  Tasks:
    - Develop Gemini prompts for personalized recommendations
    - Create recommendation scoring algorithm
    - Implement user preference learning
    - Add clarification system for ambiguous preferences
  Dependencies: Backend schema complete
  Can Start: After backend defines data structure

QA_Agent:
  Tasks:
    - Create test scenarios for recommendations
    - Validate AI recommendation quality
    - Test edge cases (new users, limited data)
    - Performance test with 1000 concurrent users
  Dependencies: Frontend and Backend complete
  Can Start: After integration
```

### Feature: "Voice Meal Logging Widget"
```yaml
Frontend_Agent:
  Tasks:
    - Create iOS Widget with voice UI
    - Implement quick-action buttons
    - Add visual feedback for recording
    - Create widget configuration view
  Dependencies: None
  Can Start: Immediately

Backend_Agent:
  Tasks:
    - Set up Firebase Storage for audio files
    - Create Cloud Function for audio processing
    - Implement transcription pipeline
    - Add meal parsing logic
  Dependencies: None
  Can Start: Immediately

AI_Agent:
  Tasks:
    - Integrate speech-to-text with Gemini
    - Develop meal extraction prompts
    - Create clarification flow for ambiguous inputs
    - Implement confidence scoring
  Dependencies: Backend audio pipeline
  Can Start: After backend setup

QA_Agent:
  Tasks:
    - Test voice recognition accuracy
    - Validate widget on different iOS versions
    - Test offline functionality
    - Create performance benchmarks
  Dependencies: All components complete
  Can Start: After integration
```

## Command Output Format

```bash
# Generated Agent Commands

## 🎨 Frontend Agent
claude-code --agent "frontend" --task "
- Create MealRecommendationView using SwiftUI 6 @Observable pattern
- Implement sophisticated green design system
- Add smooth animations and transitions
- Ensure accessibility compliance
Reference: @DesignSystem.md, @SwiftUI6Patterns.md
"

## 🔧 Backend Agent  
claude-code --agent "backend" --task "
- Design Firestore schema for meal recommendations
- Implement Cloud Functions with TypeScript
- Add proper error handling and logging
- Create efficient query indexes
Reference: @FirebaseArchitecture.md, @CloudFunctionsBestPractices.md
"

## 🤖 AI Agent
claude-code --agent "ai" --task "
- Develop Gemini Flash prompts for recommendations
- Create personalization algorithm
- Implement feedback learning system
- Add coaching insights generation
Reference: @GeminiIntegration.md, @CoachingPrompts.md
Wait for: Backend schema completion
"

## 🧪 QA Agent
claude-code --agent "qa" --task "
- Create comprehensive test suite
- Implement performance monitoring
- Add debugging dashboard features
- Validate AI coaching quality
Reference: @TestingStrategy.md, @PerformanceTargets.md
Wait for: Frontend and Backend completion
"
```

## Usage
Type `/coordinate-agents` followed by the feature description to generate parallel agent tasks.

Examples:
- `/coordinate-agents "Add recipe generation feature"`
- `/coordinate-agents "Implement sleep tracking integration"`
- `/coordinate-agents "Create onboarding flow improvements"`