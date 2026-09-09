import SwiftUI

struct RegisterFridgeItemView: View {
    @ObservedObject var viewModel: SoloPlateViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var foodName = ""
    @State private var quantity = "1"
    @State private var unit = FoodQuantityUnit.item
    @State private var useByDate = Date()
    @State private var showingError = false

    var body: some View {
        Form {
            Section("Food details") {
                TextField("Food name", text: $foodName)
                    .textInputAutocapitalization(.words)
                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)
                Picker("Unit", selection: $unit) {
                    ForEach(FoodQuantityUnit.allCases) { foodUnit in
                        Text(foodUnit.label).tag(foodUnit)
                    }
                }
                DatePicker("Use first by", selection: $useByDate, displayedComponents: .date)
            }

            Section {
                Text("This date helps SoloPlate sort your food. It does not check whether food is safe to eat.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Add Food")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if viewModel.addFood(name: foodName, quantityText: quantity, unit: unit, useByDate: useByDate) {
                        dismiss()
                    } else {
                        showingError = true
                    }
                }
            }
        }
        .alert("Food not saved", isPresented: $showingError) {
            Button("Try Again", role: .cancel) {}
        } message: {
            Text(viewModel.message ?? "Check the food details and try again.")
        }
    }
}

