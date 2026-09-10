import Foundation

// Connect the SwiftUI pages with the three business Use Cases.
final class SoloPlateViewModel: ObservableObject {
    @Published private(set) var fridgeItems: [FridgeItem] = []
    @Published private(set) var suggestions: [MealSuggestion] = []
    @Published var message: String?

    private let fridgeRepository: FridgeRepository
    private let recipeRepository: RecipeRepository

    init(fridgeRepository: FridgeRepository, recipeRepository: RecipeRepository) {
        self.fridgeRepository = fridgeRepository
        self.recipeRepository = recipeRepository
        refreshFridge()
    }

    static func live() -> SoloPlateViewModel {
        // Sample food makes the main flow easy to demonstrate in class.
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sampleItems = [
            FridgeItem(name: "Corn", quantity: 2, unit: .item, useByDate: today),
            FridgeItem(name: "Egg", quantity: 4, unit: .item, useByDate: calendar.date(byAdding: .day, value: 2, to: today)!),
            FridgeItem(name: "Sweet Potato", quantity: 1, unit: .item, useByDate: calendar.date(byAdding: .day, value: 3, to: today)!)
        ]
        return SoloPlateViewModel(
            fridgeRepository: InMemoryFridgeRepository(items: sampleItems),
            recipeRepository: BundledRecipeRepository()
        )
    }

    var sortedFridgeItems: [FridgeItem] {
        fridgeItems.sorted { $0.useByDate < $1.useByDate }
    }

    var useFirstItemID: UUID? {
        sortedFridgeItems.first?.id
    }

    func addFood(name: String, quantityText: String, unit: FoodQuantityUnit, useByDate: Date) -> Bool {
        // TextField gives a String, so change it to a number before the Use Case.
        guard let quantity = Double(quantityText) else {
            message = "Enter the quantity as a number."
            return false
        }

        do {
            try RegisterFridgeItemUseCase(fridgeRepository: fridgeRepository)
                .execute(name: name, quantity: quantity, unit: unit, useByDate: useByDate)
            refreshFridge()
            suggestions = []
            message = nil
            return true
        } catch {
            message = error.localizedDescription
            return false
        }
    }

    func findMeals() {
        do {
            suggestions = try RecommendTonightMealsUseCase(
                fridgeRepository: fridgeRepository,
                recipeRepository: recipeRepository
            ).execute()
            message = nil
        } catch {
            suggestions = []
            message = error.localizedDescription
        }
    }

    func recordPrepared(recipe: SingleServeRecipe) -> Bool {
        do {
            try RecordPreparedMealUseCase(fridgeRepository: fridgeRepository).execute(recipe: recipe)
            refreshFridge()
            suggestions = []
            message = "Meal recorded. My Fridge is now updated."
            return true
        } catch {
            message = error.localizedDescription
            return false
        }
    }

    private func refreshFridge() {
        fridgeItems = fridgeRepository.fetchItems()
    }
}
