# MCP Tools & Slash Commands for PlateUp v2.0 Development

## 🚀 Recommended MCP Servers for PlateUp

### 1. **Firebase MCP Server** (Essential)
**Repository**: `gannonh/firebase-mcp` or official Firebase MCP
**Benefits**:
- Direct Firebase project management from Claude
- 30+ tools for Firebase services
- Firestore operations without leaving Claude
- Authentication management
- Storage operations
- Emulator testing support

**Installation**:
```bash
npx firebase-mcp install
```

**Usage Examples**:
```bash
# Query Firestore directly
/mcp__firebase__query "users where goals.primary == 'energy'"

# Manage authentication
/mcp__firebase__list-users

# Test with emulators
/mcp__firebase__start-emulators
```

### 2. **Claude Code MCP** (For Agent Coordination)
**Repository**: `steipete/claude-code-mcp`
**Benefits**:
- Run Claude Code as an MCP server
- Coordinate multiple agents programmatically
- Bypass permission prompts for automated workflows

### 3. **iOS Simulator MCP** (For UI Testing)
**Benefits**:
- Take screenshots of running app
- Automate UI testing workflows
- Visual regression testing

### 4. **GitHub MCP** (For Version Control)
**Benefits**:
- Create PRs directly from Claude
- Manage issues
- Automate release workflows

## 📝 Custom Slash Commands for PlateUp

### Project-Specific Commands

Create these in `.claude/commands/`:

#### 1. **Build & Test Command**
```bash
# .claude/commands/build-test.md
---
name: build-test
description: Compile and test PlateUp with error handling
---

Compile the PlateUp project and handle any errors:

!xcodebuild -scheme PlateUp -destination 'platform=iOS Simulator,name=iPhone 16 Pro' 2>&1

If build fails, immediately apply debugging approach from:
@ClaudeDebugApproach.md

$ARGUMENTS
```

#### 2. **Firebase Deploy Command**
```bash
# .claude/commands/deploy-functions.md
---
name: deploy-functions
description: Deploy Cloud Functions with validation
---

Deploy Firebase Cloud Functions for: $ARGUMENTS

First validate TypeScript:
!cd functions && npm run build

Then deploy specific function:
!firebase deploy --only functions:$ARGUMENTS

Check deployment status and logs.
```

#### 3. **AI Coaching Test Command**
```bash
# .claude/commands/test-coaching.md
---
name: test-coaching
description: Test AI coaching responses
---

Test the AI coaching system for scenario: $ARGUMENTS

@PlateUp/Services/PersonalizedNutritionCoach.swift

Run test cases:
1. Analyze mock user data
2. Generate coaching insights
3. Validate response quality
4. Check performance metrics

!swift test --filter CoachingTests
```

#### 4. **SwiftUI Preview Command**
```bash
# .claude/commands/preview-ui.md
---
name: preview-ui
description: Generate SwiftUI preview for component
---

Generate SwiftUI preview for: $ARGUMENTS

@PlateUp/Views/$ARGUMENTS.swift

Add preview provider with:
- Multiple device sizes
- Light/dark mode variants
- Different data states
- Accessibility sizes
```

#### 5. **Green Design System Command**
```bash
# .claude/commands/apply-green.md
---
name: apply-green
description: Apply PlateUp green design system
---

Apply green design system to: $ARGUMENTS

@PlateUp/Design/PlateUpColors.swift

Ensure proper usage of:
- Context-aware green selection
- Proper contrast ratios
- Consistent shade application
- Accessibility compliance
```

### Personal Commands

Create these in `~/.claude/commands/`:

#### 1. **Search Docs Command**
```bash
# ~/.claude/commands/search-docs.md
---
name: search-docs
description: Search latest iOS/Firebase documentation
---

Search for up-to-date documentation on: $ARGUMENTS

Priority sources:
1. Apple Developer Documentation (SwiftUI 6)
2. Firebase Official Docs
3. Swift Forums
4. Stack Overflow (recent answers only)

Focus on iOS 17+ and latest Firebase SDK.
```

#### 2. **Agent Coordinator Command**
```bash
# ~/.claude/commands/coordinate-agents.md
---
name: coordinate-agents
description: Coordinate multiple agent tasks
---

Coordinate parallel agent tasks for: $ARGUMENTS

Divide work into:
- Frontend tasks (UI/SwiftUI)
- Backend tasks (Firebase/Cloud Functions)
- AI tasks (Gemini/Coaching)
- QA tasks (Testing/Debugging)

Create TodoWrite entries for each agent.
Ensure no task overlap or conflicts.
```

## 🔧 MCP Configuration for PlateUp

### Project-Level Configuration
Create `.claude/mcp_settings.json`:

```json
{
  "servers": {
    "firebase": {
      "command": "firebase-mcp",
      "args": ["--project", "plateup-v2"],
      "env": {
        "FIREBASE_PROJECT": "plateup-v2"
      }
    },
    "github": {
      "command": "github-mcp",
      "args": ["--repo", "PlateUp_v2"]
    },
    "ios-simulator": {
      "command": "ios-simulator-mcp",
      "args": ["--device", "iPhone 16 Pro"]
    }
  }
}
```

### Custom MCP Server Ideas

#### 1. **PlateUp Analytics MCP**
Create a custom MCP server that:
- Queries user analytics from Firestore
- Generates coaching insights
- Tests AI responses
- Monitors performance metrics

#### 2. **SwiftUI Component MCP**
- Generate component boilerplate
- Apply design system automatically
- Create consistent view patterns
- Add accessibility by default

#### 3. **Nutrition Database MCP**
- Query nutrition APIs
- Validate food data
- Generate meal recommendations
- Calculate macros automatically

## 🚀 Workflow Enhancements

### 1. **Automated Build Pipeline**
```bash
# Combine MCP tools for complete pipeline
/build-test && /mcp__firebase__deploy && /mcp__github__create-pr
```

### 2. **AI Coaching Development**
```bash
# Use Firebase MCP to test coaching
/mcp__firebase__query "users.testUser" | /test-coaching
```

### 3. **UI Component Creation**
```bash
# Generate consistent components
/preview-ui NewComponent && /apply-green NewComponent
```

### 4. **Debug Workflow**
```bash
# Automated debugging
/build-test --verbose | /search-docs "error message"
```

## 📊 Benefits for PlateUp Development

1. **Faster Iteration**: Direct Firebase operations without context switching
2. **Consistent Patterns**: Slash commands enforce best practices
3. **Parallel Development**: MCP servers enable true multi-agent work
4. **Automated Testing**: Build/test cycles integrated into Claude
5. **Better Debugging**: Immediate access to logs and error context

## 🎯 Implementation Priority

1. **Week 1**: Install Firebase MCP, create build-test command
2. **Week 2**: Add custom slash commands for common tasks
3. **Week 3**: Integrate GitHub MCP for PR automation
4. **Week 4**: Create custom PlateUp MCP for analytics

This setup will significantly improve your development efficiency and maintain consistency across all agents working on PlateUp v2.0.