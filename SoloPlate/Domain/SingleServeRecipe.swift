import Foundation

/// A short recipe that may be suitable for one person's meal.
/// SoloPlate only recommends recipes with one serving and no more than 15 minutes.
struct SingleServeRecipe: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let preparationMinutes: Int
    let servingCount: Int
    let ingredients: [RecipeIngredient]
    let steps: [String]

    init(
        id: UUID = UUID(),
        title: String,
        preparationMinutes: Int,
        servingCount: Int = 1,
        ingredients: [RecipeIngredient],
        steps: [String]
    ) {
        self.id = id
        self.title = title
        self.preparationMinutes = preparationMinutes
        self.servingCount = servingCount
        self.ingredients = ingredients
        self.steps = steps
    }
}

