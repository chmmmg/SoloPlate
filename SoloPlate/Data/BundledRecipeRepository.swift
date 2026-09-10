import Foundation

// Read the recipe list which is saved inside the app bundle.
struct BundledRecipeRepository: RecipeRepository {
    func fetchRecipes() -> [SingleServeRecipe] {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let recipes = try? JSONDecoder().decode([SingleServeRecipe].self, from: data) else {
            // Empty list lets the ViewModel show a useful no-meal message.
            return []
        }
        return recipes
    }
}
