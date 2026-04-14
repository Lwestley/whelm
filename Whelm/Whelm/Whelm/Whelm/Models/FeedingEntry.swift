import SwiftData
import Foundation

@Model
class FeedingEntry {
    var id: UUID
    var date: Date
    var day: Int
    var rise: String
    var bubbles: String
    var smell: String
    var notes: String
    var starter: Starter?

    init(
        day: Int,
        rise: String,
        bubbles: String,
        smell: String,
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = Date()
        self.day = day
        self.rise = rise
        self.bubbles = bubbles
        self.smell = smell
        self.notes = notes
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
