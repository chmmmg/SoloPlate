import SwiftUI

struct MyFridgeView: View {
    @ObservedObject var viewModel: SoloPlateViewModel
    @State private var showingAddFood = false

    var body: some View {
        List {
            Section {
                Text("Food with an earlier date appears first. Check the real food before cooking.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Recorded food") {
                if viewModel.sortedFridgeItems.isEmpty {
                    Text("No food recorded yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.sortedFridgeItems) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                    if item.id == viewModel.useFirstItemID {
                                        Text("USE FIRST")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 3)
                                            .background(.orange, in: Capsule())
                                    }
                                }
                                Text(item.useByDate, format: .dateTime.day().month().year())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(item.quantity.formatted()) \(item.unit.label)")
                        }
                    }
                }
            }

            Section {
                Button {
                    showingAddFood = true
                } label: {
                    Label("Add Food to Fridge", systemImage: "plus.circle.fill")
                }

                NavigationLink {
                    TonightPicksView(viewModel: viewModel)
                } label: {
                    Label("Find Tonight's Meal", systemImage: "fork.knife")
                }
                .disabled(viewModel.fridgeItems.isEmpty)
            }
        }
        .navigationTitle("My Fridge")
        .sheet(isPresented: $showingAddFood) {
            NavigationStack {
                RegisterFridgeItemView(viewModel: viewModel)
            }
        }
    }
}

