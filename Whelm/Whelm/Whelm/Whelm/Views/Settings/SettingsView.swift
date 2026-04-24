import SwiftUI
import SwiftData

struct SettingsView: View {
    let starter: Starter
    var onBack: () -> Void
    @Environment(\.modelContext) private var modelContext

    @State private var showRenameSheet = false
    @State private var newName = ""
    @State private var showDeleteConfirm = false
    @State private var dailyReminderOn = true
    @State private var peakAlertOn = false
    @State private var bakeDayRemindersOn = true

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
                    Text("your profile - Day \(starter.currentDay)")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("\(starter.name).")
                        .font(.system(size: 28, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .padding(.bottom, 28)

                    // Starter hero card
                    HStack(spacing: 18) {
                        OrbView(state: starter.orbState, size: 36, showRings: true)
                            .frame(width: 56, height: 56)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(starter.name)
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.whelmCream)
                            Text("Born \(starter.createdAt.formatted(.dateTime.month().day())) · \(starter.currentDay) \(starter.currentDay == 1 ? "day" : "days") old · \(starter.currentDay) feedings")
                                .font(.system(size: 12, weight: .light))
                                .foregroundColor(.white.opacity(0.28))
                        }

                        Spacer()

                        Button(action: {
                            newName = starter.name
                            showRenameSheet = true
                        }) {
                            Text("Rename")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.whelmAmber.opacity(0.6))
                        }
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: WhelmRadius.lg)
                            .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
                    )
                    .cornerRadius(WhelmRadius.lg)
                    .padding(.bottom, 28)

                    // Kitchen section
                    sectionLabel("Your kitchen")

                    settingsCard {
                        settingsRow(label: "Flour type", sub: "Used for ratio guidance", value: "Bread flour")
                        settingsRow(label: "Kitchen temperature", sub: "Affects fermentation timing", value: "72°F")
                        settingsRow(label: "Units", sub: "Weight and temperature", value: "Imperial")
                    }
                    .padding(.bottom, 28)

                    // Reminders section
                    sectionLabel("Reminders")

                    settingsCard {
                        toggleRow(label: "Daily feeding reminder", sub: "8:00 am every day", isOn: $dailyReminderOn)
                        toggleRow(label: "Peak activity alert", sub: "When \(starter.name) is likely at peak", isOn: $peakAlertOn)
                        toggleRow(label: "Bake day check-ins", sub: "Step reminders during a bake", isOn: $bakeDayRemindersOn)
                    }
                    .padding(.bottom, 28)

                    // Starter section
                    sectionLabel("Starter")

                    settingsCard {
                        settingsRow(label: "Reset starter journey", sub: "Start from Day 1 again", value: "")
                        dangerRow(label: "Delete \(starter.name)")
                    }
                    .padding(.bottom, 28)

                    Text("Whelm · Version 1.0")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(.white.opacity(0.12))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 8)
                }
                .padding(.horizontal, 32)
                .padding(.top, 52)
                .padding(.bottom, 48)
            }
        }
        .sheet(isPresented: $showRenameSheet) {
            renameSheet
        }
        .alert("Delete \(starter.name)?", isPresented: $showDeleteConfirm) {
            Button("Delete", role: .destructive) {
                modelContext.delete(starter)
                onBack()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete your starter and all feeding history. This cannot be undone.")
        }
    }

    var renameSheet: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Rename your starter")
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(.whelmCream)
                    .padding(.bottom, 24)

                TextField("New name", text: $newName)
                    .font(.system(size: 17, weight: .light))
                    .foregroundColor(.whelmCream)
                    .padding(18)
                    .background(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.whelmAmber.opacity(0.4), lineWidth: 0.5)
                    )
                    .cornerRadius(14)
                    .padding(.bottom, 24)

                Button(action: {
                    if !newName.isEmpty {
                        starter.name = newName
                        showRenameSheet = false
                    }
                }) {
                    Text("Save")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "1a1612"))
                        .frame(maxWidth: .infinity)
                        .padding(18)
                        .background(Color.whelmAmber)
                        .cornerRadius(14)
                }

                Spacer()
            }
            .padding(32)
            .padding(.top, 52)
        }
    }

    @ViewBuilder
    func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .medium))
            .tracking(3)
            .textCase(.uppercase)
            .foregroundColor(.white.opacity(0.2))
            .padding(.bottom, 10)
    }

    @ViewBuilder
    func settingsCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Color.white.opacity(0.03))
        .overlay(
            RoundedRectangle(cornerRadius: WhelmRadius.lg)
                .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
        )
        .cornerRadius(WhelmRadius.lg)
    }

    @ViewBuilder
    func settingsRow(label: String, sub: String, value: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                if !sub.isEmpty {
                    Text(sub)
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(.white.opacity(0.22))
                }
            }
            Spacer()
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.white.opacity(0.28))
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 10, weight: .light))
                .foregroundColor(.white.opacity(0.2))
        }
        .padding(18)
        Divider()
            .background(Color.white.opacity(0.05))
    }

    @ViewBuilder
    func toggleRow(label: String, sub: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                Text(sub)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(.white.opacity(0.22))
            }
            Spacer()
            Toggle("", isOn: isOn)
                .tint(Color.whelmAmber)
                .labelsHidden()
        }
        .padding(18)
        Divider()
            .background(Color.white.opacity(0.05))
    }

    @ViewBuilder
    func dangerRow(label: String) -> some View {
        Button(action: { showDeleteConfirm = true }) {
            HStack {
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.25))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .light))
                    .foregroundColor(Color(red: 0.7, green: 0.3, blue: 0.25).opacity(0.4))
            }
            .padding(18)
        }
    }
}

#Preview {
    SettingsView(
        starter: Starter(name: "Milo"),
        onBack: {}
    )
    .modelContainer(for: [Starter.self, FeedingEntry.self], inMemory: true)
}
