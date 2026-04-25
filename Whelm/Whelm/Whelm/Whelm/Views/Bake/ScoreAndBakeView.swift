import SwiftUI
import SwiftData

struct ScoreAndBakeView: View {
    let starter: Starter
    var onBack: () -> Void

    @State private var currentStep = 1
    @State private var timerSeconds = 0
    @State private var timerRunning = false
    @State private var timer: Timer? = nil

    struct BakeStep {
        let number: Int
        let title: String
        let desc: String
        let duration: Int
        var isDone: Bool = false
    }

    @State private var steps: [BakeStep] = [
        BakeStep(number: 1, title: "Preheat Dutch oven", desc: "500F for at least 45 min with lid on", duration: 45 * 60),
        BakeStep(number: 2, title: "Score the loaf", desc: "One confident slash at 45 degrees. Work fast — the cold dough warms quickly.", duration: 0),
        BakeStep(number: 3, title: "Bake covered", desc: "Lid on. Steam builds inside. This creates the oven spring and crust.", duration: 20 * 60),
        BakeStep(number: 4, title: "Remove lid and finish", desc: "Drop to 475F. Watch for deep amber brown — not pale, not black.", duration: 25 * 60),
        BakeStep(number: 5, title: "Rest the loaf", desc: "Wire rack. Do not cut early. The crumb is still setting inside.", duration: 60 * 60),
    ]

    var activeStep: BakeStep? {
        steps.first { $0.number == currentStep }
    }

    var fmtTimer: String {
        let m = timerSeconds / 60
        let s = timerSeconds % 60
        return "\(m):\(s < 10 ? "0" : "")\(s)"
    }

    var body: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Back button
                    HStack {
                        Button(action: {
                            timer?.invalidate()
                            onBack()
                        }) {
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
                    Text("Score and bake")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("The oven is ready.\nThis is the moment.")
                        .font(.system(size: 26, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .lineSpacing(4)
                        .padding(.bottom, 28)

                    // Active step card
                    if let step = activeStep {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Now")
                                    .font(.system(size: 10, weight: .medium))
                                    .tracking(3)
                                    .textCase(.uppercase)
                                    .foregroundColor(.whelmAmber.opacity(0.7))

                                Spacer()

                                if step.duration > 0 {
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(timerRunning ? Color.whelmAmber : Color.white.opacity(0.3))
                                            .frame(width: 5, height: 5)
                                            .animation(.easeInOut(duration: 0.8).repeatForever(), value: timerRunning)

                                        Text(timerRunning ? fmtTimer : "\(step.duration / 60) min")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(.whelmAmber)
                                            .monospacedDigit()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(Color.whelmAmber.opacity(0.1))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.whelmAmber.opacity(0.25), lineWidth: 0.5)
                                    )
                                    .clipShape(Capsule())
                                }
                            }

                            Text(step.title)
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.whelmCream)

                            Text(step.desc)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.white.opacity(0.5))
                                .lineSpacing(4)

                            // Timer button
                            if step.duration > 0 {
                                Button(action: toggleTimer) {
                                    Text(timerRunning ? "Pause timer" : (timerSeconds > 0 ? "Resume timer" : "Start timer"))
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Color(hex: "1a1612"))
                                        .frame(maxWidth: .infinity)
                                        .padding(16)
                                        .background(Color.whelmAmber)
                                        .cornerRadius(12)
                                }
                            }

                            // Next step button
                            Button(action: nextStep) {
                                Text(currentStep < steps.count ? "Next step" : "Bake complete")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                                    )
                                    .cornerRadius(12)
                            }
                        }
                        .padding(22)
                        .background(Color.whelmAmber.opacity(0.07))
                        .overlay(
                            RoundedRectangle(cornerRadius: WhelmRadius.lg)
                                .stroke(Color.whelmAmber.opacity(0.2), lineWidth: 0.5)
                        )
                        .cornerRadius(WhelmRadius.lg)
                        .padding(.bottom, 24)
                    }

                    // All steps
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Today's sequence")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(3)
                            .textCase(.uppercase)
                            .foregroundColor(.white.opacity(0.2))
                            .padding(.bottom, 12)

                        ForEach(steps, id: \.number) { step in
                            HStack(alignment: .top, spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(stepColor(step))
                                        .frame(width: 24, height: 24)
                                    if step.number < currentStep {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(.whelmAmber)
                                    } else {
                                        Text("\(step.number)")
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(step.number == currentStep ? Color(hex: "1a1612") : .white.opacity(0.2))
                                    }
                                }
                                .padding(.top, 1)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(step.title)
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(
                                            step.number < currentStep ? .white.opacity(0.25) :
                                            step.number == currentStep ? .white.opacity(0.85) :
                                            .white.opacity(0.45)
                                        )
                                        .strikethrough(step.number < currentStep, color: .white.opacity(0.15))

                                    if step.duration > 0 {
                                        Text("\(step.duration / 60) min")
                                            .font(.system(size: 11, weight: .light))
                                            .foregroundColor(.white.opacity(0.2))
                                    }
                                }

                                Spacer()
                            }
                            .padding(.vertical, 12)

                            if step.number != steps.last?.number {
                                Divider()
                                    .background(Color.white.opacity(0.05))
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 32)
                .padding(.top, 52)
                .padding(.bottom, 48)
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func stepColor(_ step: BakeStep) -> Color {
        if step.number < currentStep {
            return Color.whelmAmber.opacity(0.15)
        } else if step.number == currentStep {
            return Color.whelmAmber
        } else {
            return Color.white.opacity(0.08)
        }
    }

    func toggleTimer() {
        if timerRunning {
            timer?.invalidate()
            timerRunning = false
        } else {
            if timerSeconds == 0, let step = activeStep {
                timerSeconds = step.duration
            }
            timerRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timerSeconds > 0 {
                    timerSeconds -= 1
                } else {
                    timer?.invalidate()
                    timerRunning = false
                }
            }
        }
    }

    func nextStep() {
        timer?.invalidate()
        timerRunning = false
        timerSeconds = 0
        if currentStep < steps.count {
            currentStep += 1
        } else {
            onBack()
        }
    }
}

#Preview {
    ScoreAndBakeView(
        starter: Starter(name: "Milo"),
        onBack: {}
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
