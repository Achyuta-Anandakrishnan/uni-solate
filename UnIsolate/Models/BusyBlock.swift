import Foundation
import SwiftData

@Model
final class BusyBlock {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var source: String
    var createdAt: Date

    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date, source: String = "ICS", createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.source = source
        self.createdAt = createdAt
    }
}
