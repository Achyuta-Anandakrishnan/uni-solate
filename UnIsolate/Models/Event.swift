import Foundation
import SwiftData

@Model
final class Event {
    var id: UUID
    var school: String
    var orgName: String
    var title: String
    var category: String
    var location: String
    var startDate: Date
    var endDate: Date
    var eventDescription: String
    var tags: [String]
    var isPromoted: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        school: String,
        orgName: String,
        title: String,
        category: String,
        location: String,
        startDate: Date,
        endDate: Date,
        eventDescription: String,
        tags: [String],
        isPromoted: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.school = school
        self.orgName = orgName
        self.title = title
        self.category = category
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.eventDescription = eventDescription
        self.tags = tags
        self.isPromoted = isPromoted
        self.createdAt = createdAt
    }
}
