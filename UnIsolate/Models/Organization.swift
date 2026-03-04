import Foundation
import SwiftData

@Model
final class Organization {
    var id: UUID
    var school: String
    var name: String
    var category: String
    var organizationDescription: String
    var tags: [String]
    var isVerified: Bool
    var isPremium: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        school: String,
        name: String,
        category: String,
        organizationDescription: String,
        tags: [String],
        isVerified: Bool = true,
        isPremium: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.school = school
        self.name = name
        self.category = category
        self.organizationDescription = organizationDescription
        self.tags = tags
        self.isVerified = isVerified
        self.isPremium = isPremium
        self.createdAt = createdAt
    }
}
