import Foundation

struct BundledRecipeRepository: RecipeRepository {
    func fetchRecipes() -> [SingleServeRecipe] {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let recipes = try? JSONDecoder().decode([SingleServeRecipe].self, from: data) else {
            return []
        }
        return recipes
    }
}

