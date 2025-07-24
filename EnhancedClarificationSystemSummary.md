# Enhanced Clarification Question System - PlateUp v2.0

## Overview
I've developed a sophisticated clarification question generation system that creates more frequent and contextually meaningful questions to ensure accurate nutritional analysis.

## Key Improvements

### 1. **Context-Aware Question Generation**
The system now analyzes meal patterns and generates targeted questions based on the specific food type:

- **Ramen**: Asks about instant vs homemade vs restaurant, broth type, protein, toppings
- **Salads**: Focuses on dressing amounts, cheese, nuts, croutons
- **Sandwiches**: Queries spreads, cheese types, bread preparation
- **Beverages**: Size and additions (milk, sugar, syrups)

### 2. **Comprehensive Question Categories**
```swift
enum ClarificationCategory {
    case cookingMethod      // How was it prepared?
    case portionSize        // What size/amount?
    case hiddenIngredients  // Oils, butter, sauces
    case preparation        // Instant vs homemade
    case brandSpecific      // Restaurant/brand variations
    case saucesDressings    // Type and amount
    case beverages          // Size and additions
    case modifications      // Customizations
    case accompaniments     // Side items
    case temperature        // Hot/cold prep differences
}
```

### 3. **Priority-Based Question Selection**
Questions are prioritized by nutritional impact:
- **Critical** (>100 calorie difference): Cooking oils, major sauces
- **High** (50-100 calories): Cheese, nuts, dressings
- **Medium** (20-50 calories): Condiments, seasonings
- **Low** (<20 calories): Herbs, garnishes

### 4. **Enhanced Prompting Strategy**
The system now:
- Generates 3-5 questions (up from 1-3)
- Assumes less, clarifies more
- Thinks like a detective about hidden ingredients
- Considers all preparation variations

## Example: Ramen Analysis

For a ramen meal, the system would now generate questions like:

1. **What type of ramen was this?**
   - Instant ramen (1 package): +0 cal, +800mg sodium
   - Restaurant tonkotsu ramen: +150 cal, +15g fat
   - Homemade with light broth: -50 cal, -5g fat

2. **What protein was included?**
   - No protein: +0 cal
   - Soft-boiled egg: +70 cal, +6g protein
   - Chashu pork (3 slices): +180 cal, +12g protein, +14g fat
   - Both egg and pork: +250 cal, +18g protein, +18g fat

3. **Were any toppings added?**
   - No additional toppings: +0 cal
   - Corn and butter: +80 cal, +8g fat
   - Vegetables only (scallions, seaweed): +10 cal
   - Full toppings (corn, butter, egg, nori): +150 cal

4. **How was the broth prepared?**
   - Light shoyu broth: +0 cal (baseline)
   - Rich tonkotsu broth: +100 cal, +10g fat
   - Miso broth: +50 cal, +3g fat
   - Spicy broth with chili oil: +80 cal, +8g fat

## Implementation Details

### EnhancedClarificationPromptGenerator.swift
- Maintains a database of food patterns and common clarifications
- Analyzes meal context to identify likely missing information
- Generates sophisticated, context-aware questions
- Provides exact nutritional impact for each option

### GeminiService.swift Updates
- Integrated the enhanced prompt generator
- Updated initial analysis prompts to be more aggressive about clarifications
- Added instructions to think critically about hidden ingredients

## Benefits

1. **More Accurate Nutrition Tracking**: By asking about hidden ingredients and preparation methods
2. **Better User Experience**: Context-aware questions feel intelligent and relevant
3. **Reduced Estimation Errors**: Specific options with exact nutritional impacts
4. **Learning Opportunities**: Users become more aware of nutritional variations

## Testing the System

To test with ramen:
1. Log a meal with just "ramen" 
2. System should ask about:
   - Type (instant vs restaurant vs homemade)
   - Broth richness
   - Protein additions
   - Toppings and oils
   - Portion size

The enhanced system ensures that even simple meal descriptions result in comprehensive clarification questions, leading to more accurate nutritional analysis.