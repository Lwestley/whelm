import SwiftUI
import SwiftData

struct HomeView: View {
    let starter: Starter
    var onCheckIn: () -> Void
    var onLog: () -> Void
    var onSettings: () -> Void
    var onBakePlanner: () -> Void
    var onScoreBake: () -> Void

    @State private var dailyRead: String = "Loading today's read..."
    @State private var isLoadingRead = true

    var body: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()

            VStack(spacing: 0) {

                // Wordmark row
                HStack {
                    Spacer()
                    Text("whelm")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundColor(.white.opacity(0.18))
                    Spacer()
                    Button(action: onSettings) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white.opacity(0.25))
                    }
                }
                .padding(.top, 8)

                Spacer()

                // Starter name
                Text("\(starter.name) — your starter")
                    .font(.system(size: 13, weight: .light))
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundColor(.white.opacity(0.35))
                    .padding(.bottom, 28)

                // Orb
                OrbView(state: starter.orbState, size: 88, showRings: true)
                    .padding(.bottom, 36)

                // Day number
                Text("\(starter.currentDay)")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundColor(.whelmCream)
                    .tracking(-3)
                    .padding(.bottom, 6)

                // Day sub
                Text("of 14 days")
                    .font(.system(size: 11, weight: .light))
                    .tracking(4)
                    .textCase(.uppercase)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.bottom, 24)

                // State pill
                HStack(spacing: 7) {
                    Circle()
                        .fill(Color.whelmAmber)
                        .frame(width: 6, height: 6)
                    Text(starter.stateLabel)
                        .font(.system(size: 11, weight: .regular))
                        .tracking(1)
                        .foregroundColor(.whelmAmber.opacity(0.8))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.whelmAmber.opacity(0.1))
                .overlay(
                    Capsule()
                        .stroke(Color.whelmAmber.opacity(0.25), lineWidth: 0.5)
                )
                .clipShape(Capsule())

                Spacer()

                // Guidance card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's read")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))

                    if isLoadingRead {
                        HStack {
                            ProgressView()
                                .tint(.white.opacity(0.3))
                                .scaleEffect(0.8)
                            Text("Checking in on \(starter.name)...")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.white.opacity(0.3))
                        }
                    } else {
                        Text(dailyRead)
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(.white.opacity(0.72))
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(22)
                .background(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: WhelmRadius.lg)
                        .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
                )
                .cornerRadius(WhelmRadius.lg)
                .padding(.bottom, 12)

                // Buttons
                Button(action: onCheckIn) {
                    Text("Log today's feeding")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "1a1612"))
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(Color.whelmAmber)
                        .cornerRadius(14)
                }
                .padding(.bottom, 10)

                Button(action: onLog) {
                    Text("View feeding log")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(maxWidth: .infinity)
                        .padding(14)
                }

                Button(action: onBakePlanner) {
                    Text("Plan a bake")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(maxWidth: .infinity)
                        .padding(14)
                }

                Button(action: onScoreBake) {
                    Text("Score and bake")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.25))
                        .frame(maxWidth: .infinity)
                        .padding(14)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 52)
        }
        .onAppear {
            loadDailyRead()
        }
    }

    func loadDailyRead() {
        isLoadingRead = true
        Task {
            do {
                let result = try await ClaudeService.shared.dailyRead(
                    starterName: starter.name,
                    day: starter.currentDay,
                    flourType: starter.flourType,
                    kitchenTemp: starter.kitchenTemp,
                    units: starter.units
                )
                await MainActor.run {
                    dailyRead = result
                    isLoadingRead = false
                }
            } catch {
                await MainActor.run {
                    dailyRead = "Check in on \(starter.name) today and note what you see."
                    isLoadingRead = false
                }
            }
        }
    }
}

#Preview {
    HomeView(
        starter: Starter(name: "Milo"),
        onCheckIn: {},
        onLog: {},
        onSettings: {},
        onBakePlanner: {},
        onScoreBake: {}
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
