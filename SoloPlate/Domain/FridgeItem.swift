import Foundation

/// Food the user has recorded as available at home.
/// The date is entered by the user and is only used to decide what to show first.
struct FridgeItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var quantity: Double
    var unit: FoodQuantityUnit
    var useByDate: Date

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Double,
        unit: FoodQuantityUnit,
        useByDate: Date
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.useByDate = useByDate
    }

    var matchingName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

