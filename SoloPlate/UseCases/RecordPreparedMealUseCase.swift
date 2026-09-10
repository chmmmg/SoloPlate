import Foundation

/// Problems that stop SoloPlate from reducing the recorded food quantities.
enum RecordPreparedMealError: LocalizedError, Equatable {
    case fridgeFoodNotFound(foodName: String)
    case insufficientRecordedQuantity(foodName: String)

    var errorDescription: String? {
        switch self {
        case .fridgeFoodNotFound(let foodName):
            return "\(foodName) is missing from My Fridge. Update your fridge or choose another meal."
        case .insufficientRecordedQuantity(let foodName):
            return "There is not enough \(foodName) recorded for this meal. Update My Fridge and try again."
        }
    }
}

/// Rechecks every recipe ingredient, then updates the fridge as one complete change.
struct RecordPreparedMealUseCase {
    let fridgeRepository: FridgeRepository

    func execute(recipe: SingleServeRecipe) throws {
        let originalItems = fridgeRepository.fetchItems()
        // Work on a copy first, so failed checking will not change the real list.
        var updatedItems = originalItems

        for ingredient in recipe.ingredients {
            guard let index = updatedItems.firstIndex(where: {
                $0.matchingName == ingredient.matchingName && $0.unit == ingredient.unit
            }) else {
                throw RecordPreparedMealError.fridgeFoodNotFound(foodName: ingredient.foodName)
            }

            guard updatedItems[index].quantity >= ingredient.quantity else {
                throw RecordPreparedMealError.insufficientRecordedQuantity(foodName: ingredient.foodName)
            }
            updatedItems[index].quantity -= ingredient.quantity
        }

        // Remove food when its recorded quantity becomes exactly zero.
        updatedItems.removeAll { $0.quantity == 0 }
        fridgeRepository.replaceItems(updatedItems)
    }
}
