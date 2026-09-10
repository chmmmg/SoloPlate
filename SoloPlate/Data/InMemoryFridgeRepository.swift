import Foundation

// Keep fridge records in memory because this is only the MVP version.
final class InMemoryFridgeRepository: FridgeRepository {
    private var storedItems: [FridgeItem]

    init(items: [FridgeItem] = []) {
        storedItems = items
    }

    func fetchItems() -> [FridgeItem] {
        storedItems
    }

    func add(_ item: FridgeItem) {
        storedItems.append(item)
    }

    func replaceItems(_ items: [FridgeItem]) {
        storedItems = items
    }
}
