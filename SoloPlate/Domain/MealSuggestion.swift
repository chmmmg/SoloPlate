import Foundation

/// A recipe that matches the recorded fridge and explains why it appears.
struct MealSuggestion: Identifiable, Equatable {
    var id: UUID { recipe.id }
    let recipe: SingleServeRecipe
    let useFirstFoodName: String
    let earliestUseByDate: Date
}

