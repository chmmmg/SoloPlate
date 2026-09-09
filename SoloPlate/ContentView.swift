import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SoloPlateViewModel.live()

    var body: some View {
        NavigationStack {
            MyFridgeView(viewModel: viewModel)
        }
    }
}
