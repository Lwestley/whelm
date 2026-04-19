import SwiftUI
import SwiftData

struct CheckInView: View {
    let starter: Starter
    var onResponse: (String, [String]) -> Void
    var onBack: () -> Void
    @Environment(\.modelContext) private var modelContext

    @State private var selectedRise: String? = nil
    @State private var selectedBubbles: String? = nil
    @State private var selectedSmell: String? = nil
    @State private var notes: String = ""
    @State private var isLoading = false

    let riseOptions = ["No rise", "A little rise", "Doubled", "More than doubled"]
    let bubbleOptions = ["None", "Small bubbles", "Very bubbly", "Webby texture"]
    let smellOptions = ["Just flour", "Slightly tangy", "Sour and yeasty", "Nail polish", "Boozy"]

    var observations: [String] {
        var obs: [String] = []
        if let rise = selectedRise { obs.append("Rise: \(rise)") }
        if let bubbles = selectedBubbles { obs.append("Bubbles: \(bubbles)") }
        if let smell = selectedSmell { obs.append("Smell: \(smell)") }
        return obs
    }

    var hasObservations: Bool {
        selectedRise != nil || selectedBubbles != nil || selectedSmell != nil
    }

    var body: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Back button
                    HStack {
                        Button(action: onBack) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 12, weight: .light))
                                Text("Back")
                                    .font(.system(size: 14, weight: .light))
                            }
                            .foregroundColor(.white.opacity(0.4))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)

                    // Wordmark
                    Text("whelm")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundColor(.white.opacity(0.18))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 32)

                    // Header
                    Text("Day \(starter.currentDay) — \(starter.name)")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("How's your starter\nlooking today?")
                        .font(.system(size: 26, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .lineSpacing(4)
                        .padding(.bottom, 32)

                    // Rise
                    sectionLabel("Rise")
                    chipRow(options: riseOptions, selected: $selectedRise)
                        .padding(.bottom, 24)

                    // Bubbles
                    sectionLabel("Bubbles")
                    chipRow(options: bubbleOptions, selected: $selectedBubbles)
                        .padding(.bottom, 24)

                    // Smell
                    sectionLabel("Smell")
                    chipRow(options: smellOptions, selected: $selectedSmell)
                        .padding(.bottom, 24)

                    // Notes
                    sectionLabel("Anything else")
                    TextField("e.g. liquid on top, collapsed before I checked...", text: $notes, axis: .vertical)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(3...5)
                        .padding(16)
                        .background(Color.white.opacity(0.03))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                        )
                        .cornerRadius(14)
                        .padding(.bottom, 40)

                    // Submit button
                    Button(action: readStarter) {
                        ZStack {
                            Text("Read my starter")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "1a1612"))
                                .opacity(isLoading ? 0 : 1)

                            if isLoading {
                                ProgressView()
                                    .tint(Color(hex: "1a1612"))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(
                            hasObservations
                                ? Color.whelmAmber
                                : Color.whelmAmber.opacity(0.4)
                        )
                        .cornerRadius(14)
                    }
                    .disabled(!hasObservations || isLoading)
                }
                .padding(.horizontal, 32)
                .padding(.top, 52)
                .padding(.bottom, 48)
            }
        }
    }

    @ViewBuilder
    func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .medium))
            .tracking(3)
            .textCase(.uppercase)
            .foregroundColor(.white.opacity(0.25))
            .padding(.bottom, 12)
    }

    @ViewBuilder
    func chipRow(options: [String], selected: Binding<String?>) -> some View {
        FlowLayout(spacing: 8) {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selected.wrappedValue == option {
                        selected.wrappedValue = nil
                    } else {
                        selected.wrappedValue = option
                    }
                }) {
                    Text(option)
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(
                            selected.wrappedValue == option
                                ? Color.whelmAmber.opacity(0.9)
                                : Color.white.opacity(0.45)
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(
                            selected.wrappedValue == option
                                ? Color.whelmAmber.opacity(0.12)
                                : Color.white.opacity(0.04)
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    selected.wrappedValue == option
                                        ? Color.whelmAmber.opacity(0.4)
                                        : Color.white.opacity(0.1),
                                    lineWidth: 0.5
                                )
                        )
                        .clipShape(Capsule())
                }
            }
        }
    }

    func readStarter() {
        isLoading = true
        Task {
            do {
                let result = try await ClaudeService.shared.ask(
                    starterName: starter.name,
                    day: starter.currentDay,
                    observations: observations,
                    notes: notes
                )
                let entry = FeedingEntry(
                    day: starter.currentDay,
                    rise: selectedRise ?? "",
                    bubbles: selectedBubbles ?? "",
                    smell: selectedSmell ?? "",
                    notes: notes
                )
                entry.starter = starter
                modelContext.insert(entry)
                await MainActor.run {
                    isLoading = false
                    onResponse(result, observations)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    onResponse("Error: \(error.localizedDescription)", observations)
                }
            }
        }
    }
}

#Preview {
    CheckInView(
        starter: Starter(name: "Milo"),
        onResponse: { _, _ in },
        onBack: {}
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
