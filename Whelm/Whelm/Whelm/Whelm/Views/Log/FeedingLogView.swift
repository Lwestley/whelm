import SwiftUI
import SwiftData

struct FeedingLogView: View {
    let starter: Starter
    var onBack: () -> Void
    @Query private var entries: [FeedingEntry]

    init(starter: Starter, onBack: @escaping () -> Void) {
        self.starter = starter
        self.onBack = onBack
        let starterID = starter.id
        self._entries = Query(
            filter: #Predicate<FeedingEntry> { entry in
                entry.starter?.id == starterID
            },
            sort: \FeedingEntry.date,
            order: .reverse
        )
    }

    var avgRise: String {
        let doubles = entries.filter { $0.rise == "Doubled" || $0.rise == "More than doubled" }
        let pct = entries.isEmpty ? 0 : Int((Double(doubles.count) / Double(entries.count)) * 100)
        return "\(pct)%"
    }

    var body: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

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

                    Text("whelm")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundColor(.white.opacity(0.18))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 32)

                    Text("\(starter.name)'s log")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("\(starter.currentDay) \(starter.currentDay == 1 ? "day" : "days") in.")
                        .font(.system(size: 28, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .padding(.bottom, 28)

                    HStack(spacing: 10) {
                        statCard(value: "\(entries.count)", label: "Feedings")
                        statCard(value: "\(starter.currentDay)", label: "Days alive")
                        statCard(value: avgRise, label: "Doubled")
                    }
                    .padding(.bottom, 28)

                    if entries.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("No feedings logged yet.")
                                .font(.system(size: 15, weight: .light))
                                .foregroundColor(.white.opacity(0.35))
                            Text("After your first check-in, entries will appear here.")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(.white.opacity(0.2))
                                .lineSpacing(4)
                        }
                        .padding(.top, 8)
                    } else {
                        Text("This week")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(3)
                            .textCase(.uppercase)
                            .foregroundColor(.white.opacity(0.2))
                            .padding(.bottom, 12)

                        VStack(spacing: 0) {
                            ForEach(entries) { entry in
                                logRow(entry: entry)
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 52)
                .padding(.bottom, 48)
            }
        }
    }

    @ViewBuilder
    func statCard(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .ultraLight))
                .foregroundColor(.whelmCream)
                .tracking(-0.5)
            Text(label)
                .font(.system(size: 10, weight: .regular))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundColor(.white.opacity(0.22))
        }
        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.04))
        .overlay(
            RoundedRectangle(cornerRadius: WhelmRadius.sm)
                .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
        )
        .cornerRadius(WhelmRadius.sm)
    }

    @ViewBuilder
    func logRow(entry: FeedingEntry) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 6) {
                Text("\(entry.day)")
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.white.opacity(0.5))

                Circle()
                    .fill(activityColor(entry: entry))
                    .frame(width: 5, height: 5)

                Rectangle()
                    .fill(Color.white.opacity(0.06))
                    .frame(width: 0.5)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 36)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Morning feeding")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(entry.timeString)
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(.white.opacity(0.2))
                }

                HStack(spacing: 6) {
                    if !entry.rise.isEmpty {
                        tag(entry.rise, highlight: entry.rise == "Doubled" || entry.rise == "More than doubled")
                    }
                    if !entry.bubbles.isEmpty {
                        tag(entry.bubbles, highlight: entry.bubbles == "Very bubbly" || entry.bubbles == "Webby texture")
                    }
                    if !entry.smell.isEmpty {
                        tag(entry.smell, highlight: entry.smell == "Sour and yeasty")
                    }
                }

                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.22))
                        .lineSpacing(3)
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.top, 12)

        Divider()
            .background(Color.white.opacity(0.05))
    }

    @ViewBuilder
    func tag(_ text: String, highlight: Bool) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .light))
            .foregroundColor(highlight ? Color.whelmAmber.opacity(0.75) : Color.white.opacity(0.3))
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(highlight ? Color.whelmAmber.opacity(0.08) : Color.white.opacity(0.04))
            .overlay(
                Capsule()
                    .stroke(
                        highlight ? Color.whelmAmber.opacity(0.18) : Color.white.opacity(0.07),
                        lineWidth: 0.5
                    )
            )
            .clipShape(Capsule())
    }

    func activityColor(entry: FeedingEntry) -> Color {
        if entry.rise == "Doubled" || entry.rise == "More than doubled" {
            return Color.whelmAmber
        } else if entry.rise == "A little rise" {
            return Color.whelmAmber.opacity(0.5)
        } else {
            return Color.white.opacity(0.2)
        }
    }
}

#Preview {
    FeedingLogView(
        starter: Starter(name: "Milo"),
        onBack: {}
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
