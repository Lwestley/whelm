import SwiftUI
import SwiftData

struct BakePlannerView: View {
    let starter: Starter
    var onBack: () -> Void

    @State private var selectedDay = "Tomorrow"
    @State private var selectedHour = 12
    @State private var selectedMinute = 0
    @State private var isAM = false
    @State private var proofMethod = "overnight"

    let days = ["Today", "Tomorrow", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"]

    var eatTime: (hour: Int, minute: Int) {
        var h = selectedHour
        if !isAM && h != 12 { h += 12 }
        if isAM && h == 12 { h = 0 }
        return (h, selectedMinute)
    }

    struct ScheduleItem {
        let time: String
        let name: String
        let sub: String
        var isEat: Bool = false
    }

    func sub(_ base: (hour: Int, minute: Int), _ mins: Int) -> (hour: Int, minute: Int) {
        var total = base.hour * 60 + base.minute - mins
        if total < 0 { total += 1440 }
        return (total / 60 % 24, total % 60)
    }

    func fmt(_ t: (hour: Int, minute: Int)) -> String {
        let h = t.hour % 12 == 0 ? 12 : t.hour % 12
        let m = t.minute < 10 ? "0\(t.minute)" : "\(t.minute)"
        let ampm = t.hour < 12 ? "am" : "pm"
        return "\(h):\(m)\(ampm)"
    }

    var schedule: [ScheduleItem] {
        let eat = eatTime
        if proofMethod == "overnight" {
            let rest      = sub(eat, 60)
            let bakeStart = sub(rest, 45)
            let score     = sub(bakeStart, 10)
            let shape     = (21, 0)
            let preshape  = sub(shape, 30)
            let bulkEnd   = preshape
            let bulkStart = sub(bulkEnd, 300)
            let salt      = bulkStart
            let aut       = sub(salt, 50)
            return [
                ScheduleItem(time: fmt(aut),      name: "Autolyse",         sub: "Flour and water, rest 45 min"),
                ScheduleItem(time: fmt(salt),     name: "Add \(starter.name) and salt", sub: "Begin bulk fermentation"),
                ScheduleItem(time: "\(fmt(bulkStart)) to \(fmt(bulkEnd))", name: "Bulk fermentation", sub: "4 to 6 hours, stretch and folds"),
                ScheduleItem(time: fmt(preshape), name: "Pre-shape",        sub: "30 min bench rest"),
                ScheduleItem(time: fmt(shape),    name: "Final shape",      sub: "Into banneton, into fridge"),
                ScheduleItem(time: "Overnight",   name: "Cold proof",       sub: "8 to 16 hours"),
                ScheduleItem(time: fmt(score),    name: "Score",            sub: "Straight from cold"),
                ScheduleItem(time: fmt(bakeStart),name: "Bake",             sub: "500F Dutch oven, 45 min"),
                ScheduleItem(time: fmt(rest),     name: "Rest",             sub: "1 hour before cutting"),
                ScheduleItem(time: fmt(eat),      name: "Eat",              sub: "", isEat: true),
            ]
        } else {
            let rest       = sub(eat, 60)
            let bakeStart  = sub(rest, 45)
            let proofEnd   = sub(bakeStart, 5)
            let proofStart = sub(proofEnd, 120)
            let shape      = proofStart
            let preshape   = sub(shape, 30)
            let bulkEnd    = preshape
            let bulkStart  = sub(bulkEnd, 300)
            let salt       = bulkStart
            let aut        = sub(salt, 50)
            return [
                ScheduleItem(time: fmt(aut),      name: "Autolyse",         sub: "Flour and water, rest 45 min"),
                ScheduleItem(time: fmt(salt),     name: "Add \(starter.name) and salt", sub: "Begin bulk fermentation"),
                ScheduleItem(time: "\(fmt(bulkStart)) to \(fmt(bulkEnd))", name: "Bulk fermentation", sub: "4 to 6 hrs, stretch and folds"),
                ScheduleItem(time: fmt(preshape), name: "Pre-shape",        sub: "30 min bench rest"),
                ScheduleItem(time: fmt(shape),    name: "Final shape",      sub: "Into the banneton"),
                ScheduleItem(time: "\(fmt(proofStart)) to \(fmt(proofEnd))", name: "Room temp proof", sub: "2 hours"),
                ScheduleItem(time: fmt(bakeStart),name: "Bake",             sub: "500F Dutch oven, 45 min"),
                ScheduleItem(time: fmt(rest),     name: "Rest",             sub: "1 hour before cutting"),
                ScheduleItem(time: fmt(eat),      name: "Eat",              sub: "", isEat: true),
            ]
        }
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
                    Text("Bake planner")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("Give us a time.\nWe'll give you a plan.")
                        .font(.system(size: 26, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .lineSpacing(4)
                        .padding(.bottom, 28)

                    // Target card
                    VStack(alignment: .leading, spacing: 16) {

                        // Day picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Day")
                                .font(.system(size: 10, weight: .medium))
                                .tracking(3)
                                .textCase(.uppercase)
                                .foregroundColor(.white.opacity(0.22))

                            Menu {
                                ForEach(days, id: \.self) { day in
                                    Button(day) { selectedDay = day }
                                }
                            } label: {
                                HStack {
                                    Text(selectedDay)
                                        .font(.system(size: 15, weight: .light))
                                        .foregroundColor(.whelmCream)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 11, weight: .light))
                                        .foregroundColor(.white.opacity(0.3))
                                }
                                .padding(15)
                                .background(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                )
                                .cornerRadius(12)
                            }
                        }

                        // Time picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(.system(size: 10, weight: .medium))
                                .tracking(3)
                                .textCase(.uppercase)
                                .foregroundColor(.white.opacity(0.22))

                            HStack(spacing: 8) {
                                // Hour
                                Menu {
                                    ForEach(1...12, id: \.self) { h in
                                        Button("\(h)") { selectedHour = h }
                                    }
                                } label: {
                                    HStack {
                                        Text("\(selectedHour)")
                                            .font(.system(size: 15, weight: .light))
                                            .foregroundColor(.whelmCream)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 11, weight: .light))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    .padding(15)
                                    .background(Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                    )
                                    .cornerRadius(12)
                                }
                                .frame(maxWidth: .infinity)

                                // Minute
                                Menu {
                                    ForEach([0, 15, 30, 45], id: \.self) { m in
                                        Button(m == 0 ? "00" : "\(m)") { selectedMinute = m }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedMinute == 0 ? "00" : "\(selectedMinute)")
                                            .font(.system(size: 15, weight: .light))
                                            .foregroundColor(.whelmCream)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 11, weight: .light))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    .padding(15)
                                    .background(Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                    )
                                    .cornerRadius(12)
                                }
                                .frame(maxWidth: .infinity)

                                // AM/PM
                                HStack(spacing: 0) {
                                    Button(action: { isAM = true }) {
                                        Text("AM")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(isAM ? Color(hex: "1a1612") : .white.opacity(0.4))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 15)
                                            .background(isAM ? Color.whelmAmber : Color.clear)
                                    }
                                    Button(action: { isAM = false }) {
                                        Text("PM")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(!isAM ? Color(hex: "1a1612") : .white.opacity(0.4))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 15)
                                            .background(!isAM ? Color.whelmAmber : Color.clear)
                                    }
                                }
                                .background(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                )
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity)
                            }
                        }

                        // Proof method
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Proof method")
                                .font(.system(size: 10, weight: .medium))
                                .tracking(3)
                                .textCase(.uppercase)
                                .foregroundColor(.white.opacity(0.22))

                            HStack(spacing: 8) {
                                proofChip(label: "Cold overnight", value: "overnight")
                                proofChip(label: "Same day", value: "same-day")
                            }
                        }
                    }
                    .padding(22)
                    .background(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: WhelmRadius.lg)
                            .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
                    )
                    .cornerRadius(WhelmRadius.lg)
                    .padding(.bottom, 20)

                    // Schedule card
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Your schedule")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(3)
                            .textCase(.uppercase)
                            .foregroundColor(.whelmAmber.opacity(0.5))
                            .padding(.bottom, 14)

                        ForEach(Array(schedule.enumerated()), id: \.offset) { _, item in
                            HStack(alignment: .top, spacing: 16) {
                                Text(item.time)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.whelmAmber.opacity(0.6))
                                    .frame(width: 70, alignment: .leading)
                                    .fixedSize()

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.system(size: 13, weight: item.isEat ? .regular : .regular))
                                        .foregroundColor(item.isEat ? .whelmAmber : .white.opacity(0.65))
                                    if !item.sub.isEmpty {
                                        Text(item.sub)
                                            .font(.system(size: 11, weight: .light))
                                            .foregroundColor(.white.opacity(0.2))
                                    }
                                }
                            }
                            .padding(.vertical, 9)

                            if item.name != schedule.last?.name {
                                Divider()
                                    .background(Color.white.opacity(0.04))
                            }
                        }
                    }
                    .padding(22)
                    .background(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: WhelmRadius.lg)
                            .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
                    )
                    .cornerRadius(WhelmRadius.lg)
                    .padding(.bottom, 20)

                    // Start button
                    Button(action: onBack) {
                        Text("Start this plan")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "1a1612"))
                            .frame(maxWidth: .infinity)
                            .padding(18)
                            .background(Color.whelmAmber)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 52)
                .padding(.bottom, 48)
            }
        }
    }

    @ViewBuilder
    func proofChip(label: String, value: String) -> some View {
        Button(action: { proofMethod = value }) {
            Text(label)
                .font(.system(size: 13, weight: .light))
                .foregroundColor(proofMethod == value ? Color.whelmAmber.opacity(0.9) : Color.white.opacity(0.35))
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(proofMethod == value ? Color.whelmAmber.opacity(0.12) : Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            proofMethod == value ? Color.whelmAmber.opacity(0.35) : Color.white.opacity(0.08),
                            lineWidth: 0.5
                        )
                )
                .cornerRadius(12)
        }
    }
}

#Preview {
    BakePlannerView(
        starter: Starter(name: "Milo"),
        onBack: {}
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
