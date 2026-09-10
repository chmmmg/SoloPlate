import SwiftUI

// Show the quick meals which match the current fridge quantities.
struct TonightPicksView: View {
    @ObservedObject var viewModel: SoloPlateViewModel

    var body: some View {
        List {
            if let message = viewModel.message, viewModel.suggestions.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("No meal found", systemImage: "exclamationmark.circle")
                            .font(.headline)
                        Text(message)
                            .foregroundStyle(.secondary)
                        Text("Go back to My Fridge to add food or correct a quantity.")
                            .font(.footnote)
                    }
                    .padding(.vertical, 6)
                }
            }

            ForEach(viewModel.suggestions) { suggestion in
                NavigationLink {
                    MealRecipeDetailView(viewModel: viewModel, suggestion: suggestion)
                } label: {
                    VStack(alignment: .leading, spacing: 7) {
                        Text(suggestion.recipe.title)
                            .font(.headline)
                        Text("\(suggestion.recipe.preparationMinutes) min · 1 serving")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label("Uses \(suggestion.useFirstFoodName) first", systemImage: "clock")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Tonight's Picks")
        .onAppear {
            // Refresh suggestions because the fridge may be changed before coming here.
            viewModel.findMeals()
        }
    }
}
