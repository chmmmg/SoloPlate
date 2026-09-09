import Foundation

/// One food and quantity needed for a recipe.
struct RecipeIngredient: Codable, Equatable, Identifiable {
    var id: String { "\(foodName.lowercased())-\(unit.rawValue)" }
    let foodName: String
    let quantity: Double
    let unit: FoodQuantityUnit

    var matchingName: String {
        foodName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

