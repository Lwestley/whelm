import SwiftUI
import SwiftData

@Model
class Starter {
    var id: UUID
    var name: String
    var createdAt: Date
    var lastFedAt: Date?
    var currentDay: Int
    var isReady: Bool
    var flourType: String
    var kitchenTemp: Double
    var units: String

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.lastFedAt = nil
        self.currentDay = 1
        self.isReady = false
        self.flourType = "Bread flour"
        self.kitchenTemp = 72.0
        self.units = "Imperial"
    }

    var daysSinceCreation: Int {
        Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
    }

    var calculatedDay: Int {
        let days = Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
        return min(days + 1, 14)
    }

    var orbState: OrbState {
        switch currentDay {
        case 1...2: return .dormant
        case 3...5: return .waking
        case 6...11: return .active
        default: return .peak
        }
    }

    var stateLabel: String {
        switch orbState {
        case .dormant: return "Just getting started"
        case .waking: return "Waking up"
        case .active: return "Getting strong"
        case .peak: return "Ready to bake"
        }
    }
}
