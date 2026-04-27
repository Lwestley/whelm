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
    @State private var showUnitPicker = false
    @State private var showFlourPicker = false
    @State private var showTempPicker = false
    @State private var selectedUnit: String
    @State private var selectedFlour: String
    @State private var kitchenTemp: Double
    @State private var showResetConfirm = false

    init(starter: Starter, onBack: @escaping () -> Void) {
        self.starter = starter
        self.onBack = onBack
        self._selectedUnit = State(initialValue: starter.units)
        self._selectedFlour = State(initialValue: starter.flourType)
        self._kitchenTemp = State(initialValue: starter.kitchenTemp)
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

                    Text("Day \(starter.currentDay) — your profile")
                        .font(.system(size: 10, weight: .medium))
                        .tracking(3)
                        .textCase(.uppercase)
                        .foregroundColor(.whelmAmber.opacity(0.6))
                        .padding(.bottom, 10)

                    Text("\(starter.name).")
                        .font(.system(size: 28, weight: .ultraLight))
                        .foregroundColor(.whelmCream)
                        .padding(.bottom, 28)

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

                    sectionLabel("Your kitchen")

                    settingsCard {
                        Button(action: { showFlourPicker = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Flour type")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.65))
                                    Text("Used for ratio guidance")
                                        .font(.system(size: 11, weight: .light))
                                        .foregroundColor(.white.opacity(0.22))
                                }
                                Spacer()
                                Text(selectedFlour)
                                    .font(.system(size: 13, weight: .light))
                                    .foregroundColor(.white.opacity(0.28))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(.white.opacity(0.2))
                            }
                            .padding(18)
                        }

                        Divider().background(Color.white.opacity(0.05))

                        Button(action: { showTempPicker = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Kitchen temperature")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.65))
                                    Text("Affects fermentation timing")
                                        .font(.system(size: 11, weight: .light))
                                        .foregroundColor(.white.opacity(0.22))
                                }
                                Spacer()
                                Text("\(Int(kitchenTemp))°\(selectedUnit == "Imperial" ? "F" : "C")")
                                    .font(.system(size: 13, weight: .light))
                                    .foregroundColor(.white.opacity(0.28))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(.white.opacity(0.2))
                            }
                            .padding(18)
                        }

                        Divider().background(Color.white.opacity(0.05))

                        Button(action: { showUnitPicker = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Units")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.65))
                                    Text("Weight and temperature")
                                        .font(.system(size: 11, weight: .light))
                                        .foregroundColor(.white.opacity(0.22))
                                }
                                Spacer()
                                Text(selectedUnit)
                                    .font(.system(size: 13, weight: .light))
                                    .foregroundColor(.white.opacity(0.28))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(.white.opacity(0.2))
                            }
                            .padding(18)
                        }
                    }
                    .padding(.bottom, 28)

                    sectionLabel("Reminders")

                    settingsCard {
                        toggleRow(label: "Daily feeding reminder", sub: "8:00 am every day", isOn: $dailyReminderOn)
                        toggleRow(label: "Peak activity alert", sub: "When \(starter.name) is likely at peak", isOn: $peakAlertOn)
                        toggleRow(label: "Bake day check-ins", sub: "Step reminders during a bake", isOn: $bakeDayRemindersOn)
                    }
                    .padding(.bottom, 28)

                    sectionLabel("Starter")

                    settingsCard {
                        Button(action: { showResetConfirm = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Reset starter journey")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.65))
                                    Text("Start from Day 1 again")
                                        .font(.system(size: 11, weight: .light))
                                        .foregroundColor(.white.opacity(0.22))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(.white.opacity(0.2))
                            }
                            .padding(18)
                        };
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
        .onChange(of: selectedUnit) { _, newValue in
            starter.units = newValue
        }
        .onChange(of: selectedFlour) { _, newValue in
            starter.flourType = newValue
        }
        .onChange(of: kitchenTemp) { _, newValue in
            starter.kitchenTemp = newValue
        }
        .sheet(isPresented: $showRenameSheet) {
            renameSheet
        }
        .sheet(isPresented: $showFlourPicker) {
            pickerSheet(
                title: "Flour type",
                options: ["Bread flour", "All-purpose", "Whole wheat", "Rye", "Spelt"],
                selected: $selectedFlour,
                isPresented: $showFlourPicker
            )
        }
        .sheet(isPresented: $showUnitPicker) {
            pickerSheet(
                title: "Units",
                options: ["Imperial", "Metric"],
                selected: $selectedUnit,
                isPresented: $showUnitPicker
            )
        }
        .sheet(isPresented: $showTempPicker) {
            tempSheet
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
        .alert("Reset \(starter.name)?", isPresented: $showResetConfirm) {
            Button("Reset", role: .destructive) {
                starter.currentDay = 1
                starter.createdAt = Date()
                starter.lastFedAt = nil
                starter.isReady = false
                onBack()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will reset \(starter.name) back to Day 1. Your feeding history will be kept.")
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

    var tempSheet: some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Text("Kitchen temperature")
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(.whelmCream)
                    .padding(.bottom, 8)

                Text("Whelm uses this to calibrate fermentation timing advice.")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.white.opacity(0.35))
                    .lineSpacing(4)
                    .padding(.bottom, 48)

                Text("\(Int(kitchenTemp))°\(selectedUnit == "Imperial" ? "F" : "C")")
                    .font(.system(size: 64, weight: .ultraLight))
                    .foregroundColor(.whelmCream)
                    .tracking(-2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 32)

                Slider(
                    value: $kitchenTemp,
                    in: selectedUnit == "Imperial" ? 60...85 : 15...30,
                    step: 1
                )
                .tint(Color.whelmAmber)
                .padding(.bottom, 16)

                HStack {
                    Text(selectedUnit == "Imperial" ? "60°F" : "15°C")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.25))
                    Spacer()
                    Text(selectedUnit == "Imperial" ? "85°F" : "30°C")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.white.opacity(0.25))
                }
                .padding(.bottom, 48)

                Button(action: { showTempPicker = false }) {
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

    func pickerSheet(title: String, options: [String], selected: Binding<String>, isPresented: Binding<Bool>) -> some View {
        ZStack {
            Color.whelmBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(.whelmCream)
                    .padding(.bottom, 28)

                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selected.wrappedValue = option
                            isPresented.wrappedValue = false
                        }) {
                            HStack {
                                Text(option)
                                    .font(.system(size: 15, weight: .light))
                                    .foregroundColor(.white.opacity(0.7))
                                Spacer()
                                if selected.wrappedValue == option {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.whelmAmber)
                                }
                            }
                            .padding(18)
                        }
                        if option != options.last {
                            Divider().background(Color.white.opacity(0.05))
                        }
                    }
                }
                .background(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: WhelmRadius.lg)
                        .stroke(Color.white.opacity(0.07), lineWidth: 0.5)
                )
                .cornerRadius(WhelmRadius.lg)

                Spacer()
            }
            .padding(32)
            .padding(.top, 52)
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
