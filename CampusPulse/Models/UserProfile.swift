import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var email: String
    var school: String
    var interests: [String]
    var stepsPerDay: Int
    var sleepHours: Double
    var includeNearbySchools: Bool
    var involvementLevel: Int
    var connectionScore: Int
    var createdAt: Date
    var hasCompletedOnboarding: Bool

    init(
        id: UUID = UUID(),
        email: String = "",
        school: String = "NC State",
        interests: [String] = [],
        stepsPerDay: Int = 5000,
        sleepHours: Double = 7,
        includeNearbySchools: Bool = false,
        involvementLevel: Int = 0,
        connectionScore: Int = 50,
        createdAt: Date = .now,
        hasCompletedOnboarding: Bool = false
    ) {
        self.id = id
        self.email = email
        self.school = school
        self.interests = interests
        self.stepsPerDay = stepsPerDay
        self.sleepHours = sleepHours
        self.includeNearbySchools = includeNearbySchools
        self.involvementLevel = involvementLevel
        self.connectionScore = connectionScore
        self.createdAt = createdAt
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
