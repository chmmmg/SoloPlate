import Foundation

/// Provides the recipes which can be checked by the recommendation Use Case.
protocol RecipeRepository {
    func fetchRecipes() -> [SingleServeRecipe]
}
