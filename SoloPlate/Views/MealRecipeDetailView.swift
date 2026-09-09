import SwiftUI

struct MealRecipeDetailView: View {
    @ObservedObject var viewModel: SoloPlateViewModel
    let suggestion: MealSuggestion
    @State private var showingConfirmation = false
    @State private var showingResult = false

    var body: some View {
        List {
            Section {
                Label("\(suggestion.recipe.preparationMinutes) minutes", systemImage: "clock")
                Label("1 serving", systemImage: "person")
                Text("Suggested because \(suggestion.useFirstFoodName) has the earliest recorded date.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Ingredients") {
                ForEach(suggestion.recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.foodName)
                        Spacer()
                        Text("\(ingredient.quantity.formatted()) \(ingredient.unit.label)")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Steps") {
                ForEach(Array(suggestion.recipe.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top) {
                        Text("\(index + 1)")
                            .font(.headline)
                            .frame(width: 24, height: 24)
                            .background(.green.opacity(0.18), in: Circle())
                        Text(step)
                    }
                }
            }

            Section {
                Button("Meal Prepared") {
                    showingConfirmation = true
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .tint(.green)
            } footer: {
                Text("Only confirm after cooking. SoloPlate will recheck and update every recorded quantity.")
            }
        }
        .navigationTitle(suggestion.recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Have you prepared this meal?", isPresented: $showingConfirmation) {
            Button("Yes, Update My Fridge") {
                _ = viewModel.recordPrepared(recipe: suggestion.recipe)
                showingResult = true
            }
            Button("Not Yet", role: .cancel) {}
        }
        .alert("SoloPlate", isPresented: $showingResult) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.message ?? "My Fridge was not changed.")
        }
    }
}

