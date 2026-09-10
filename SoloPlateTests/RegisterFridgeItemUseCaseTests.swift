import XCTest
@testable import SoloPlate

// Check the normal input and the main mistakes when user adds food.
final class RegisterFridgeItemUseCaseTests: XCTestCase {
    private let calendar = Calendar(identifier: .gregorian)
    private let today = Date(timeIntervalSince1970: 1_800_000_000)

    func test_registerFridgeItem_savesFood_whenNameQuantityAndDateAreValid() throws {
        let repository = InMemoryFridgeRepository()
        let useCase = RegisterFridgeItemUseCase(fridgeRepository: repository, calendar: calendar)

        try useCase.execute(name: "Corn", quantity: 2, unit: .item, useByDate: today, today: today)

        XCTAssertEqual(repository.fetchItems().count, 1)
        XCTAssertEqual(repository.fetchItems().first?.name, "Corn")
    }

    func test_registerFridgeItem_fails_whenFoodNameIsBlank() {
        let repository = InMemoryFridgeRepository()
        let useCase = RegisterFridgeItemUseCase(fridgeRepository: repository, calendar: calendar)

        XCTAssertThrowsError(try useCase.execute(name: "  ", quantity: 1, unit: .item, useByDate: today, today: today)) {
            XCTAssertEqual($0 as? RegisterFridgeItemError, .missingFoodName)
        }
        XCTAssertTrue(repository.fetchItems().isEmpty)
    }

    func test_registerFridgeItem_fails_whenQuantityIsZero() {
        let repository = InMemoryFridgeRepository()
        let useCase = RegisterFridgeItemUseCase(fridgeRepository: repository, calendar: calendar)

        XCTAssertThrowsError(try useCase.execute(name: "Egg", quantity: 0, unit: .item, useByDate: today, today: today)) {
            XCTAssertEqual($0 as? RegisterFridgeItemError, .nonPositiveQuantity)
        }
    }

    func test_registerFridgeItem_fails_whenUseByDateIsBeforeToday() {
        let repository = InMemoryFridgeRepository()
        let useCase = RegisterFridgeItemUseCase(fridgeRepository: repository, calendar: calendar)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        XCTAssertThrowsError(try useCase.execute(name: "Spinach", quantity: 1, unit: .bag, useByDate: yesterday, today: today)) {
            XCTAssertEqual($0 as? RegisterFridgeItemError, .useByDateAlreadyPassed)
        }
    }
}
