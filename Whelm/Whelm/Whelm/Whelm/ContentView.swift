import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        OnboardingView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
