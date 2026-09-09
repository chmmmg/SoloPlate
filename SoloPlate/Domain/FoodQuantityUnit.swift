import Foundation

/// A unit used to record food in the fridge.
enum FoodQuantityUnit: String, Codable, CaseIterable, Identifiable {
    case item
    case gram
    case millilitre
    case bag

    var id: String { rawValue }

    var label: String {
        switch self {
        case .item: return "item"
        case .gram: return "g"
        case .millilitre: return "ml"
        case .bag: return "bag"
        }
    }
}

