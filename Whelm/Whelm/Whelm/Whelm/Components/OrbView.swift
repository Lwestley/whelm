import SwiftUI

enum OrbState {
    case dormant
    case waking
    case active
    case peak
}

struct OrbView: View {
    var state: OrbState = .active
    var size: CGFloat = 88
    var showRings: Bool = true

    @State private var breathing = false
    @State private var pulsing = false

    var ringCount: Int {
        switch state {
        case .dormant: return 1
        case .waking: return 2
        case .active: return 3
        case .peak: return 3
        }
    }

    var glowOpacity: Double {
        switch state {
        case .dormant: return 0.05
        case .waking: return 0.12
        case .active: return 0.2
        case .peak: return 0.35
        }
    }

    var coreOpacity: Double {
        switch state {
        case .dormant: return 0.4
        case .waking: return 0.6
        case .active: return 0.85
        case .peak: return 1.0
        }
    }

    var breatheScale: CGFloat {
        switch state {
        case .dormant: return 1.02
        case .waking: return 1.04
        case .active: return 1.06
        case .peak: return 1.08
        }
    }

    var body: some View {
        ZStack {
            if showRings {
                ForEach(0..<ringCount, id: \.self) { i in
                    Circle()
                        .stroke(
                            Color.whelmAmber.opacity(0.1 + Double(i) * 0.07),
                            lineWidth: 0.5
                        )
                        .frame(
                            width: size + CGFloat(ringCount - i) * 30,
                            height: size + CGFloat(ringCount - i) * 30
                        )
                        .scaleEffect(pulsing ? 1.04 : 1.0)
                        .opacity(pulsing ? 1.0 : 0.6)
                        .animation(
                            .easeInOut(duration: 3.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.5),
                            value: pulsing
                        )
                }
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "e8b96a").opacity(coreOpacity),
                            Color(hex: "c4964e").opacity(coreOpacity),
                            Color(hex: "8b6232").opacity(coreOpacity),
                            Color(hex: "5c3d18")
                        ],
                        center: UnitPoint(x: 0.35, y: 0.32),
                        startRadius: 0,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size, height: size)
                .shadow(
                    color: Color.whelmAmber.opacity(glowOpacity),
                    radius: size * 0.5
                )
                .scaleEffect(breathing ? breatheScale : 1.0)
                .animation(
                    .easeInOut(duration: 5.0)
                    .repeatForever(autoreverses: true),
                    value: breathing
                )

            Ellipse()
                .fill(Color.white.opacity(0.12))
                .frame(width: size * 0.3, height: size * 0.18)
                .offset(x: -size * 0.12, y: -size * 0.22)
                .blur(radius: 4)
        }
        .frame(
            width: size + CGFloat(ringCount) * 30,
            height: size + CGFloat(ringCount) * 30
        )
        .onAppear {
            breathing = true
            pulsing = true
        }
    }
}

#Preview {
    ZStack {
        Color.whelmBackground.ignoresSafeArea()
        VStack(spacing: 48) {
            OrbView(state: .dormant, size: 60)
            OrbView(state: .waking, size: 72)
            OrbView(state: .active, size: 88)
            OrbView(state: .peak, size: 100)
        }
    }
}
