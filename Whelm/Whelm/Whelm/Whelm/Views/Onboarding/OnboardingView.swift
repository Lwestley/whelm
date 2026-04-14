import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var starterName: String = ""
    @State private var navigateToHome = false
    @State private var newStarter: Starter?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.whelmBackground.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {

                    // Wordmark
                    Text("whelm")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundColor(.white.opacity(0.18))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    Spacer()

                    // Orb centered
                    OrbView(state: .dormant, size: 64, showRings: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 44)

                    // Eyebrow
                    Text("Day 1")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 12)

                    // Headline
                    Text("Every starter\nneeds a name.")
                        .font(.system(size: 30, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .lineSpacing(4)
                        .padding(.bottom, 14)

                    // Subline
                    Text("Name it something that feels alive — you'll be checking in on it every day for the next two weeks.")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.35))
                        .lineSpacing(5)
                        .padding(.bottom, 44)

                    // Input label
                    Text("Your starter's name")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.white.opacity(0.25))
                        .padding(.bottom, 10)

                    // Name input
                    TextField("e.g. Milo, Dough Boy, Agnes...", text: $starterName)
                        .font(.system(size: 17, weight: .light))
                        .foregroundColor(.whelmCream)
                        .padding(18)
                        .background(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    starterName.isEmpty
                                        ? Color.white.opacity(0.12)
                                        : Color.whelmAmber.opacity(0.4),
                                    lineWidth: 0.5
                                )
                        )
                        .cornerRadius(14)
                        .padding(.bottom, 10)

                    // Hint
                    Text("You can always rename it later.")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.18))
                        .padding(.bottom, 44)

                    Spacer()

                    // Begin button
                    Button(action: beginDay1) {
                        Text("Begin Day 1")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "1a1612"))
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(
                                starterName.isEmpty
                                    ? Color.whelmAmber.opacity(0.4)
                                    : Color.whelmAmber
                            )
                            .cornerRadius(14)
                    }
                    .disabled(starterName.isEmpty)
                    .padding(.bottom, 10)

                    // Already have a starter
                    Button(action: {}) {
                        Text("I already have a starter")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.25))
                            .frame(maxWidth: .infinity)
                            .padding(14)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 52)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                if let starter = newStarter {
                    HomeView(starter: starter)
                }
            }
        }
    }

    func beginDay1() {
        guard !starterName.isEmpty else { return }
        let starter = Starter(name: starterName)
        modelContext.insert(starter)
        newStarter = starter
        navigateToHome = true
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
