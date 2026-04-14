import SwiftUI
import SwiftData

@main
struct WhelmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Starter.self, FeedingEntry.self])
    }
}
