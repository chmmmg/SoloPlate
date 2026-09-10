import Foundation

/// Problems the user may meet when asking for tonight's meal.
enum RecommendTonightMealsError: LocalizedError, Equatable {
    case noUsableFridgeFood
    case noMatchingSingleServeRecipe

    var errorDescription: String? {
        switch self {
        case .noUsableFridgeFood:
            return "Your fridge list is empty. Add some food before finding a meal."
        case .noMatchingSingleServeRecipe:
            return "No 15-minute meal matches your recorded food. Update your fridge quantities and try again."
        }
    }
}

/// Finds quick meals for one that can be made from the recorded fridge quantities.
struct RecommendTonightMealsUseCase {
    let fridgeRepository: FridgeRepository
    let recipeRepository: RecipeRepository

    func execute() throws -> [MealSuggestion] {
        let items = fridgeRepository.fetchItems().filter { $0.quantity > 0 }
        guard !items.isEmpty else {
            throw RecommendTonightMealsError.noUsableFridgeFood
        }

        let suggestions = recipeRepository.fetchRecipes().compactMap { recipe -> MealSuggestion? in
            // The MVP only gives quick recipes for one person.
            guard recipe.servingCount == 1, recipe.preparationMinutes <= 15 else {
                return nil
            }

            let matchingItems = recipe.ingredients.compactMap { ingredient in
                items.first {
                    $0.matchingName == ingredient.matchingName &&
                    $0.unit == ingredient.unit &&
                    $0.quantity >= ingredient.quantity
                }
            }

            guard matchingItems.count == recipe.ingredients.count,
                  let useFirstItem = matchingItems.min(by: { $0.useByDate < $1.useByDate }) else {
                return nil
            }

            return MealSuggestion(
                recipe: recipe,
                useFirstFoodName: useFirstItem.name,
                earliestUseByDate: useFirstItem.useByDate
            )
        }
        .sorted {
            // Earlier food date comes first, then the faster recipe comes first.
            if $0.earliestUseByDate == $1.earliestUseByDate {
                return $0.recipe.preparationMinutes < $1.recipe.preparationMinutes
            }
            return $0.earliestUseByDate < $1.earliestUseByDate
        }

        guard !suggestions.isEmpty else {
            throw RecommendTonightMealsError.noMatchingSingleServeRecipe
        }
        return suggestions
    }
}
