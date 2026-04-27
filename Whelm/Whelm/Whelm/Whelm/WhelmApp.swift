import SwiftUI
import SwiftData
import UserNotifications

@main
struct WhelmApp: App {
    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Starter.self, FeedingEntry.self])
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                scheduleDailyReminder()
            }
        }
    }

    func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["whelm.daily"])

        let content = UNMutableNotificationContent()
        content.title = "Whelm"
        content.body = "Your starter is waiting. Time to check in."
        content.sound = .default

        var components = DateComponents()
        components.hour = 8
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "whelm.daily", content: content, trigger: trigger)

        center.add(request)
    }
}
