import Foundation

enum RegisterFridgeItemError: LocalizedError, Equatable {
    case missingFoodName
    case nonPositiveQuantity
    case useByDateAlreadyPassed

    var errorDescription: String? {
        switch self {
        case .missingFoodName:
            return "Enter the food name so SoloPlate can match it to a meal."
        case .nonPositiveQuantity:
            return "Enter a quantity greater than zero."
        case .useByDateAlreadyPassed:
            return "Check the date. New fridge food cannot use a past date."
        }
    }
}

/// Checks a new fridge record and saves it when the values are useful for meal matching.
struct RegisterFridgeItemUseCase {
    let fridgeRepository: FridgeRepository
    var calendar: Calendar = .current

    @discardableResult
    func execute(name: String, quantity: Double, unit: FoodQuantityUnit, useByDate: Date, today: Date = Date()) throws -> FridgeItem {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else {
            throw RegisterFridgeItemError.missingFoodName
        }
        guard quantity > 0 else {
            throw RegisterFridgeItemError.nonPositiveQuantity
        }
        guard calendar.startOfDay(for: useByDate) >= calendar.startOfDay(for: today) else {
            throw RegisterFridgeItemError.useByDateAlreadyPassed
        }

        let item = FridgeItem(name: cleanName, quantity: quantity, unit: unit, useByDate: useByDate)
        fridgeRepository.add(item)
        return item
    }
}

