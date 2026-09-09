import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.green)

                Text("SoloPlate")
                    .font(.largeTitle.bold())

                Text("Use what is already in your fridge.")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

