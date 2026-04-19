import SwiftUI
import SwiftData

enum AppScreen {
    case onboarding
    case home
    case checkIn
    case response(String, [String])
    case log
}

struct ContentView: View {
    @Query private var starters: [Starter]
    @State private var screen: AppScreen = .onboarding
    @State private var currentStarter: Starter?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            switch screen {
            case .onboarding:
                OnboardingView(onComplete: { starter in
                    currentStarter = starter
                    screen = .home
                })
            case .home:
                if let starter = currentStarter ?? starters.first {
                    HomeView(
                        starter: starter,
                        onCheckIn: { screen = .checkIn },
                        onLog: { screen = .log }
                    )
                }
            case .checkIn:
                if let starter = currentStarter ?? starters.first {
                    CheckInView(
                        starter: starter,
                        onResponse: { response, observations in
                            screen = .response(response, observations)
                        },
                        onBack: { screen = .home }
                    )
                }
            case .response(let response, let observations):
                if let starter = currentStarter ?? starters.first {
                    ResponseView(
                        starter: starter,
                        observations: observations,
                        response: response,
                        onBack: { screen = .home }
                    )
                }
            case .log:
                if let starter = currentStarter ?? starters.first {
                    FeedingLogView(
                        starter: starter,
                        onBack: { screen = .home }
                    )
                }
            }
        }
        .onAppear {
            if let existing = starters.first {
                currentStarter = existing
                screen = .home
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
