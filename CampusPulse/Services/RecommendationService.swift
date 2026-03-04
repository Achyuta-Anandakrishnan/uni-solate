import Foundation

struct ScoredEvent: Identifiable {
    let id = UUID()
    let event: Event
    let score: Int
    let reason: String
}

struct RecommendationService {
    static func recommend(
        events: [Event],
        profile: UserProfile,
        windows: [FreeWindow],
        riskScore: Int
    ) -> [ScoredEvent] {
        let schools = profile.includeNearbySchools ? [profile.school, "UNC", "Duke"] : [profile.school]

        let filtered = events.filter { schools.contains($0.school) }
            .filter { event in
                windows.contains { event.startDate >= $0.start && event.endDate <= $0.end }
            }

        return filtered.map { event in
            var score = 0
            var reasons: [String] = []
            if !Set(profile.interests).isDisjoint(with: event.tags) {
                score += 40
                reasons.append("Matches your interests")
            }
            if riskScore >= 65 && event.category.lowercased().contains("social") {
                score += 25
                reasons.append("Great for social connection")
            }
            if profile.stepsPerDay < 6000 && event.category.lowercased().contains("active") {
                score += 25
                reasons.append("Boosts your activity")
            }
            if event.isPromoted {
                score += 10
                reasons.append("Featured by campus")
            }
            if event.startDate.timeIntervalSinceNow < 72 * 3600 {
                score += 10
                reasons.append("Happening soon")
            }
            return ScoredEvent(event: event, score: score, reason: reasons.joined(separator: " • "))
        }
        .sorted { $0.score > $1.score }
        .prefix(10)
        .map { $0 }
    }
}
