import Foundation

/// The actions SoloPlate needs for reading and changing the user's fridge list.
protocol FridgeRepository: AnyObject {
    func fetchItems() -> [FridgeItem]
    func add(_ item: FridgeItem)
    func replaceItems(_ items: [FridgeItem])
}
