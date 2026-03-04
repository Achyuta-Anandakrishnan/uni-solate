import Foundation
import SwiftData

@Model
final class Attendance {
    var id: UUID
    var eventId: UUID
    var status: String
    var wantsBuddy: Bool
    var buddyGroupCount: Int
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        eventId: UUID,
        status: String = "going",
        wantsBuddy: Bool = false,
        buddyGroupCount: Int = 0,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.eventId = eventId
        self.status = status
        self.wantsBuddy = wantsBuddy
        self.buddyGroupCount = buddyGroupCount
        self.updatedAt = updatedAt
    }
}
