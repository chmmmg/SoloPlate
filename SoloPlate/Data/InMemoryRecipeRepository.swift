import Foundation

// This small repository is mainly useful when testing a list of recipes.
struct InMemoryRecipeRepository: RecipeRepository {
    let recipes: [SingleServeRecipe]

    func fetchRecipes() -> [SingleServeRecipe] {
        recipes
    }
}
