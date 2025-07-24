//
//  FoodIcon.swift
//  PlateUp
//
//  Food icon mapping system inspired by MacroFactor
//

import SwiftUI

struct FoodIcon {
    static func icon(for foodName: String) -> String {
        let lowercased = foodName.lowercased()
        
        // Check for exact matches first
        if let exactMatch = iconMapping[lowercased] {
            return exactMatch
        }
        
        // Check for partial matches
        for (key, icon) in iconMapping {
            if lowercased.contains(key) {
                return icon
            }
        }
        
        // Return default food icon
        return "🍽️"
    }
    
    private static let iconMapping: [String: String] = [
        // Fruits
        "banana": "🍌",
        "apple": "🍎",
        "orange": "🍊",
        "grape": "🍇",
        "strawberry": "🍓",
        "blueberry": "🫐",
        "raspberry": "🫐",
        "pear": "🍐",
        "peach": "🍑",
        "pineapple": "🍍",
        "watermelon": "🍉",
        "melon": "🍈",
        "lemon": "🍋",
        "lime": "🍋",
        "cherry": "🍒",
        "mango": "🥭",
        "coconut": "🥥",
        "kiwi": "🥝",
        
        // Vegetables
        "broccoli": "🥦",
        "carrot": "🥕",
        "corn": "🌽",
        "mushroom": "🍄",
        "tomato": "🍅",
        "cucumber": "🥒",
        "lettuce": "🥬",
        "salad": "🥗",
        "pepper": "🌶️",
        "bell pepper": "🫑",
        "onion": "🧅",
        "garlic": "🧄",
        "potato": "🥔",
        "sweet potato": "🍠",
        "eggplant": "🍆",
        "avocado": "🥑",
        
        // Proteins
        "chicken": "🍗",
        "turkey": "🦃",
        "beef": "🥩",
        "steak": "🥩",
        "pork": "🥓",
        "bacon": "🥓",
        "ham": "🍖",
        "fish": "🐟",
        "salmon": "🐟",
        "tuna": "🐟",
        "shrimp": "🦐",
        "lobster": "🦞",
        "crab": "🦀",
        "egg": "🥚",
        "tofu": "🟦",
        
        // Grains & Carbs
        "bread": "🍞",
        "toast": "🍞",
        "bagel": "🥯",
        "croissant": "🥐",
        "rice": "🍚",
        "pasta": "🍝",
        "spaghetti": "🍝",
        "noodles": "🍜",
        "pizza": "🍕",
        "sandwich": "🥪",
        "burger": "🍔",
        "taco": "🌮",
        "burrito": "🌯",
        "wrap": "🌯",
        "pancake": "🥞",
        "waffle": "🧇",
        "cereal": "🥣",
        "oatmeal": "🥣",
        
        // Dairy
        "milk": "🥛",
        "cheese": "🧀",
        "yogurt": "🥛",
        "butter": "🧈",
        "ice cream": "🍨",
        
        // Drinks
        "water": "💧",
        "coffee": "☕",
        "tea": "🍵",
        "juice": "🧃",
        "smoothie": "🥤",
        "protein shake": "🥤",
        "soda": "🥤",
        "beer": "🍺",
        "wine": "🍷",
        
        // Snacks & Desserts
        "cookie": "🍪",
        "cake": "🍰",
        "pie": "🥧",
        "donut": "🍩",
        "chocolate": "🍫",
        "candy": "🍬",
        "chips": "🍿",
        "popcorn": "🍿",
        "pretzel": "🥨",
        "nuts": "🥜",
        "peanut": "🥜",
        "almond": "🌰",
        
        // Asian Foods
        "sushi": "🍱",
        "ramen": "🍜",
        "dumpling": "🥟",
        "spring roll": "🥟",
        
        // Other
        "soup": "🍲",
        "stew": "🍲",
        "curry": "🍛",
        "honey": "🍯",
        "maple syrup": "🥞",
        "jam": "🍓",
        "peanut butter": "🥜",
        "olive oil": "🫒",
        "oil": "🛢️",
        "sauce": "🥫",
        "salt": "🧂",
        "herb": "🌿",
        "spice": "🌶️"
    ]
}

// View component for displaying food with icon
struct FoodItemRow: View {
    let ingredient: MealAnalysis.Ingredient
    
    var body: some View {
        HStack(spacing: 12) {
            // Food icon
            Text(ingredient.icon ?? FoodIcon.icon(for: ingredient.name))
                .font(.title2)
                .frame(width: 32, height: 32)
            
            // Food details
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("\(ingredient.quantity, specifier: "%.1f") \(ingredient.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Nutrition info
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(ingredient.nutrition.calories)) cal")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    MacroLabel(value: ingredient.nutrition.protein, unit: "P", color: .red)
                    MacroLabel(value: ingredient.nutrition.carbs, unit: "C", color: .blue)
                    MacroLabel(value: ingredient.nutrition.fat, unit: "F", color: .yellow)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct MacroLabel: View {
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 2) {
            Text("\(Int(value))")
                .font(.caption)
                .fontWeight(.medium)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .foregroundColor(color)
    }
}

// Extension for meal display
extension Meal {
    var displayIcon: String {
        // Return the most prominent ingredient's icon
        guard let analysis = analysis,
              let firstIngredient = analysis.ingredients.first else {
            return "🍽️"
        }
        
        return firstIngredient.icon ?? FoodIcon.icon(for: firstIngredient.name)
    }
    
    var allIcons: [String] {
        // Return up to 3 unique icons for the meal
        guard let analysis = analysis else { return ["🍽️"] }
        
        let icons = analysis.ingredients
            .compactMap { $0.icon ?? FoodIcon.icon(for: $0.name) }
            .unique()
            .prefix(3)
        
        return Array(icons)
    }
}

// Helper extension for unique array elements
extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

// Preview
struct FoodIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("Food Icon Examples")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(["Grilled Chicken Breast", "Garden Salad", "Banana", "Pasta with Tomato Sauce", "Greek Yogurt"], id: \.self) { food in
                HStack {
                    Text(FoodIcon.icon(for: food))
                        .font(.title)
                    Text(food)
                        .font(.body)
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
}