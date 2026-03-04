import Foundation
import SwiftData

struct SeedService {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Event>()
        if (try? context.fetchCount(descriptor)) ?? 0 > 0 { return }

        let organizations: [(String, String, String, [String])] = [
            ("NC State", "Society of Entrepreneurs", "Business", ["Entrepreneurship", "Startups"]),
            ("NC State", "Neurotech", "Engineering", ["AI", "Engineering"]),
            ("NC State", "Aquapack Robotics", "Engineering", ["Robotics", "Engineering"]),
            ("NC State", "Society of Sales Engineers", "Business", ["Sales", "Engineering"]),
            ("NC State", "SolarPack", "Engineering", ["Engineering", "Outdoor"]),
            ("NC State", "Sales Club", "Business", ["Sales", "Business"]),
            ("NC State", "IEEE", "Engineering", ["Engineering", "AI"]),
            ("NC State", "HackNC", "Technology", ["AI", "Gaming"]),
            ("NC State", "Outdoor Adventures", "Active", ["Outdoor", "Fitness"]),
            ("NC State", "Engineers Without Borders", "Volunteering", ["Volunteering", "Engineering"]),
            ("UNC", "Carolina Creators", "Startups", ["Startups", "Business"]),
            ("UNC", "Tar Heel Volunteers", "Volunteering", ["Volunteering", "Music"]),
            ("UNC", "UNC Robotics", "Engineering", ["Robotics", "AI"]),
            ("Duke", "Blue Devils in Tech", "Technology", ["AI", "Engineering"]),
            ("Duke", "Duke Outdoors", "Active", ["Outdoor", "Fitness"]),
            ("Duke", "Duke Social Impact", "Volunteering", ["Volunteering", "Business"])
        ]

        for org in organizations {
            context.insert(Organization(
                school: org.0,
                name: org.1,
                category: org.2,
                organizationDescription: "\(org.1) helps students build community through hands-on campus events.",
                tags: org.3,
                isVerified: true,
                isPremium: org.1.contains("HackNC") || org.1.contains("Blue Devils")
            ))
        }

        let locations = ["Talley Student Union", "Hunt Library", "Witherspoon Hall", "Fetzer Gym", "Duke Student Center", "Wilson Library"]
        let cal = Calendar.current

        for idx in 0..<36 {
            let org = organizations[idx % organizations.count]
            let dayOffset = idx % 14
            let hour = 9 + (idx % 10)
            let day = cal.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
            let start = cal.date(bySettingHour: hour, minute: 0, second: 0, of: day) ?? day
            let end = cal.date(byAdding: .hour, value: 2, to: start) ?? start.addingTimeInterval(7200)

            let category = idx % 5 == 0 ? "Social" : (idx % 4 == 0 ? "Active" : org.2)
            context.insert(Event(
                school: org.0,
                orgName: org.1,
                title: "\(org.1) Session \(idx + 1)",
                category: category,
                location: locations[idx % locations.count],
                startDate: start,
                endDate: end,
                eventDescription: "Connect with peers, build skills, and discover community opportunities.",
                tags: org.3,
                isPromoted: idx % 6 == 0
            ))
        }

        try? context.save()
    }
}
