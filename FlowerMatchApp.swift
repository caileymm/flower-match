import SwiftUI

@main
struct FlowerMatchApp: App {
    var body: some Scene {
        WindowGroup {
            MemoryGameView(viewModel: MemoryGameViewModel())
        }
    }
}
