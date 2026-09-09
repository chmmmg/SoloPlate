import Foundation

protocol RecipeRepository {
    func fetchRecipes() -> [SingleServeRecipe]
}

