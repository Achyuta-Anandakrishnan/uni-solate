import Foundation

struct RiskScoreService {
    static func score(stepsPerDay: Int, sleepHours: Double, plannedEvents: Int) -> Int {
        var risk = 80.0
        risk -= min(Double(stepsPerDay) / 150.0, 35)
        risk -= max(min((sleepHours - 6) * 8, 20), 0)
        risk -= min(Double(plannedEvents * 10), 25)
        return Int(max(0, min(100, risk)))
    }

    static func label(for score: Int) -> String {
        switch score {
        case 0...29: "Low"
        case 30...64: "Medium"
        default: "High"
        }
    }

    static func drivers(stepsPerDay: Int, sleepHours: Double, plannedEvents: Int) -> [String] {
        [
            stepsPerDay < 7000 ? "Low movement this week" : "Movement trending positive",
            sleepHours < 7 ? "Sleep trending short" : "Sleep consistency improving",
            plannedEvents < 2 ? "Few social plans scheduled" : "Social calendar building"
        ]
    }
}
