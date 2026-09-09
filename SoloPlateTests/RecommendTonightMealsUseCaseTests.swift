import XCTest
@testable import SoloPlate

final class RecommendTonightMealsUseCaseTests: XCTestCase {
    private let today = Date(timeIntervalSince1970: 1_800_000_000)

    func test_recommendTonightMeals_returnsRecipe_whenAllIngredientsAreAvailable() throws {
        let meal = recipe(title: "Corn and Egg Bowl", minutes: 12, ingredients: [
            RecipeIngredient(foodName: "Corn", quantity: 1, unit: .item),
            RecipeIngredient(foodName: "Egg", quantity: 2, unit: .item)
        ])
        let useCase = makeUseCase(items: [item("Corn", 1), item("Egg", 2)], recipes: [meal])

        let result = try useCase.execute()

        XCTAssertEqual(result.map(\.recipe.title), ["Corn and Egg Bowl"])
    }

    func test_recommendTonightMeals_includesRecipe_whenPreparationTimeIsExactly15Minutes() throws {
        let meal = recipe(title: "Quick Sweet Potato", minutes: 15)
        let result = try makeUseCase(items: [item("Corn", 1)], recipes: [meal]).execute()

        XCTAssertEqual(result.first?.recipe.preparationMinutes, 15)
    }

    func test_recommendTonightMeals_prioritisesRecipeUsingEarliestDatedFood() throws {
        let later = today.addingTimeInterval(3 * 86_400)
        let items = [item("Corn", 1, date: later), item("Egg", 2, date: today)]
        let cornMeal = recipe(title: "Corn Cup", minutes: 8)
        let eggMeal = recipe(
            title: "Fast Eggs",
            minutes: 10,
            ingredients: [RecipeIngredient(foodName: "Egg", quantity: 2, unit: .item)]
        )

        let result = try makeUseCase(items: items, recipes: [cornMeal, eggMeal]).execute()

        XCTAssertEqual(result.first?.recipe.title, "Fast Eggs")
        XCTAssertEqual(result.first?.useFirstFoodName, "Egg")
    }

    func test_recommendTonightMeals_excludesRecipe_whenItTakesMoreThan15Minutes() {
        let slowMeal = recipe(title: "Slow Corn", minutes: 16)
        let useCase = makeUseCase(items: [item("Corn", 2)], recipes: [slowMeal])

        XCTAssertThrowsError(try useCase.execute()) {
            XCTAssertEqual($0 as? RecommendTonightMealsError, .noMatchingSingleServeRecipe)
        }
    }

    func test_recommendTonightMeals_fails_whenNoRecipeMatchesRecordedStock() {
        let useCase = makeUseCase(items: [item("Egg", 1)], recipes: [recipe(title: "Corn Cup", minutes: 8)])

        XCTAssertThrowsError(try useCase.execute()) {
            XCTAssertEqual($0 as? RecommendTonightMealsError, .noMatchingSingleServeRecipe)
        }
    }

    func test_recommendTonightMeals_fails_whenFridgeIsEmpty() {
        let useCase = makeUseCase(items: [], recipes: [recipe(title: "Corn Cup", minutes: 8)])

        XCTAssertThrowsError(try useCase.execute()) {
            XCTAssertEqual($0 as? RecommendTonightMealsError, .noUsableFridgeFood)
        }
    }

    private func item(_ name: String, _ quantity: Double, date: Date? = nil) -> FridgeItem {
        FridgeItem(name: name, quantity: quantity, unit: .item, useByDate: date ?? today)
    }

    private func recipe(title: String, minutes: Int, ingredients: [RecipeIngredient]? = nil) -> SingleServeRecipe {
        SingleServeRecipe(
            title: title,
            preparationMinutes: minutes,
            ingredients: ingredients ?? [RecipeIngredient(foodName: "Corn", quantity: 1, unit: .item)],
            steps: ["Prepare the food."]
        )
    }

    private func makeUseCase(items: [FridgeItem], recipes: [SingleServeRecipe]) -> RecommendTonightMealsUseCase {
        RecommendTonightMealsUseCase(
            fridgeRepository: InMemoryFridgeRepository(items: items),
            recipeRepository: InMemoryRecipeRepository(recipes: recipes)
        )
    }
}

