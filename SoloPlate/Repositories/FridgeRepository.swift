import Foundation

protocol FridgeRepository: AnyObject {
    func fetchItems() -> [FridgeItem]
    func add(_ item: FridgeItem)
    func replaceItems(_ items: [FridgeItem])
}

