import SwiftUI

// Keep one ViewModel so all pages can use the same fridge data.
struct ContentView: View {
    @StateObject private var viewModel = SoloPlateViewModel.live()

    var body: some View {
        NavigationStack {
            MyFridgeView(viewModel: viewModel)
        }
    }
}
