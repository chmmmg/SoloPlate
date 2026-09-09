import Foundation

struct InMemoryRecipeRepository: RecipeRepository {
    let recipes: [SingleServeRecipe]

    func fetchRecipes() -> [SingleServeRecipe] {
        recipes
    }
}

