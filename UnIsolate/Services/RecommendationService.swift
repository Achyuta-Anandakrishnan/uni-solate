import Foundation

struct ScoredEvent: Identifiable {
    let id = UUID()
    let event: Event
    let score: Int
    let reasons: [String]

    var whyRecommended: String {
        reasons.isEmpty ? "Fits your schedule" : reasons.joined(separator: " • ")
    }

    var closestMeetingText: String {
        "Closest meeting: \(event.startDate.formatted(date: .abbreviated, time: .shortened))"
    }
}

struct RecommendationService {
    static func recommend(
        events: [Event],
        profile: UserProfile,
        windows: [FreeWindow],
        riskScore: Int
    ) -> [ScoredEvent] {
        let schools = profile.includeNearbySchools ? [profile.school, "UNC", "Duke"] : [profile.school]

        return events
            .filter { schools.contains($0.school) && $0.endDate > .now }
            .filter { event in
                windows.contains { event.startDate >= $0.start && event.endDate <= $0.end }
            }
            .map { event in
                var score = 0
                var reasons: [String] = ["Schedule-fit"]

                if !Set(profile.interests).isDisjoint(with: event.tags) {
                    score += 40
                    reasons.append("Interest match")
                }

                if riskScore >= 65 && event.category.localizedCaseInsensitiveContains("social") {
                    score += 25
                    reasons.append("Supports social connection")
                }

                if profile.stepsPerDay < 6000 && event.category.localizedCaseInsensitiveContains("active") {
                    score += 25
                    reasons.append("Active lifestyle boost")
                }

                if event.isPromoted {
                    score += 10
                    reasons.append("Promoted")
                }

                if event.startDate.timeIntervalSinceNow <= 72 * 3600 {
                    score += 10
                    reasons.append("Soon")
                }

                return ScoredEvent(event: event, score: score, reasons: reasons)
            }
            .sorted { lhs, rhs in
                if lhs.score == rhs.score {
                    return lhs.event.startDate < rhs.event.startDate
                }
                return lhs.score > rhs.score
            }
            .prefix(10)
            .map { $0 }
    }
}
