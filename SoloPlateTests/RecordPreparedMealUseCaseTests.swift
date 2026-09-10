import XCTest
@testable import SoloPlate

// Check that preparing a meal updates all quantities safely.
final class RecordPreparedMealUseCaseTests: XCTestCase {
    private let today = Date(timeIntervalSince1970: 1_800_000_000)

    func test_recordPreparedMeal_reducesAllRequiredFridgeQuantities() throws {
        let repository = InMemoryFridgeRepository(items: [item("Corn", 2), item("Egg", 4)])
        let meal = recipe(ingredients: [ingredient("Corn", 1), ingredient("Egg", 2)])

        try RecordPreparedMealUseCase(fridgeRepository: repository).execute(recipe: meal)

        XCTAssertEqual(repository.fetchItems().first(where: { $0.name == "Corn" })?.quantity, 1)
        XCTAssertEqual(repository.fetchItems().first(where: { $0.name == "Egg" })?.quantity, 2)
    }

    func test_recordPreparedMeal_removesFood_whenTheFullRecordedQuantityIsUsed() throws {
        let repository = InMemoryFridgeRepository(items: [item("Corn", 1)])

        try RecordPreparedMealUseCase(fridgeRepository: repository).execute(recipe: recipe(ingredients: [ingredient("Corn", 1)]))

        XCTAssertTrue(repository.fetchItems().isEmpty)
    }

    func test_recordPreparedMeal_fails_whenIngredientIsMissing() {
        let repository = InMemoryFridgeRepository(items: [item("Corn", 1)])
        let useCase = RecordPreparedMealUseCase(fridgeRepository: repository)

        XCTAssertThrowsError(try useCase.execute(recipe: recipe(ingredients: [ingredient("Egg", 1)]))) {
            XCTAssertEqual($0 as? RecordPreparedMealError, .fridgeFoodNotFound(foodName: "Egg"))
        }
    }

    func test_recordPreparedMeal_fails_whenIngredientQuantityIsInsufficient() {
        let repository = InMemoryFridgeRepository(items: [item("Egg", 1)])
        let useCase = RecordPreparedMealUseCase(fridgeRepository: repository)

        XCTAssertThrowsError(try useCase.execute(recipe: recipe(ingredients: [ingredient("Egg", 2)]))) {
            XCTAssertEqual($0 as? RecordPreparedMealError, .insufficientRecordedQuantity(foodName: "Egg"))
        }
    }

    func test_recordPreparedMeal_keepsInventoryUnchanged_whenAnyUpdateFails() {
        // Corn should not reduce when Egg checking fails later.
        let original = [item("Corn", 2), item("Egg", 1)]
        let repository = InMemoryFridgeRepository(items: original)
        let meal = recipe(ingredients: [ingredient("Corn", 1), ingredient("Egg", 2)])

        XCTAssertThrowsError(try RecordPreparedMealUseCase(fridgeRepository: repository).execute(recipe: meal))
        XCTAssertEqual(repository.fetchItems(), original)
    }

    private func item(_ name: String, _ quantity: Double) -> FridgeItem {
        FridgeItem(name: name, quantity: quantity, unit: .item, useByDate: today)
    }

    private func ingredient(_ name: String, _ quantity: Double) -> RecipeIngredient {
        RecipeIngredient(foodName: name, quantity: quantity, unit: .item)
    }

    private func recipe(ingredients: [RecipeIngredient]) -> SingleServeRecipe {
        SingleServeRecipe(title: "Test Meal", preparationMinutes: 10, ingredients: ingredients, steps: ["Cook."])
    }
}
