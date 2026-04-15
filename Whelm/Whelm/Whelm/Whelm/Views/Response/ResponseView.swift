import SwiftUI
import SwiftData

struct ResponseView: View {
    let starter: Starter
    let observations: [String]
    let response: String

    var body: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    Text("whelm")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(4)
                        .textCase(.uppercase)
                        .foregroundColor(.white.opacity(0.18))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 32)

                    Text("Day \(starter.currentDay) — \(starter.name)")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("Here's what\nWhelm thinks.")
                        .font(.system(size: 26, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .lineSpacing(4)
                        .padding(.bottom, 32)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Whelm's read")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(3)
                            .textCase(.uppercase)
                            .foregroundColor(.whelmAmber.opacity(0.6))

                        Text(response)
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(.white.opacity(0.72))
                            .lineSpacing(5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(22)
                    .background(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: WhelmRadius.lg)
                            .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
                    )
                    .cornerRadius(WhelmRadius.lg)
                }
                .padding(.horizontal, 32)
                .padding(.top, 52)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ResponseView(
        starter: Starter(name: "Milo"),
        observations: ["Rise: Doubled", "Smell: Sour and yeasty"],
        response: "Milo is looking great. Those bubbles and that rise tell you fermentation is well underway."
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
