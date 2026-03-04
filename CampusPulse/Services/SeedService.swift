import Foundation
import SwiftData

struct SeedService {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Event>()
        if (try? context.fetchCount(descriptor)) ?? 0 > 0 { return }

        let organizations = [
            ("NC State", "Society of Entrepreneurs", "Business"), ("NC State", "Neurotech", "Engineering"),
            ("NC State", "Aquapack Robotics", "Engineering"), ("NC State", "Society of Sales Engineers", "Business"),
            ("NC State", "SolarPack", "Engineering"), ("NC State", "Sales Club", "Business"),
            ("NC State", "IEEE", "Engineering"), ("NC State", "HackNC", "Technology"),
            ("NC State", "Outdoor Adventures", "Active"), ("NC State", "Engineers Without Borders", "Volunteering"),
            ("UNC", "Carolina Creators", "Startups"), ("UNC", "Tar Heel Volunteers", "Volunteering"),
            ("Duke", "Blue Devils in Tech", "Technology"), ("Duke", "Duke Outdoors", "Active")
        ]

        organizations.forEach {
            context.insert(Organization(school: $0.0, name: $0.1, category: $0.2, organizationDescription: "\($0.1) brings students together.", tags: [$0.2], isPremium: Bool.random()))
        }

        let categories = ["Social", "Active", "Engineering", "Business", "Volunteering"]
        let schools = ["NC State", "UNC", "Duke"]
        let cal = Calendar.current

        for idx in 0..<36 {
            let school = schools[idx % schools.count]
            let dayOffset = idx % 14
            let hour = 10 + (idx % 9)
            let start = cal.date(byAdding: .day, value: dayOffset, to: Date())!
            let startDate = cal.date(bySettingHour: hour, minute: 0, second: 0, of: start)!
            let endDate = cal.date(byAdding: .hour, value: 2, to: startDate)!
            let category = categories[idx % categories.count]
            context.insert(Event(
                school: school,
                orgName: organizations[idx % organizations.count].1,
                title: "\(category) Meetup \(idx + 1)",
                category: category,
                location: "Student Center Room \(100 + idx)",
                startDate: startDate,
                endDate: endDate,
                eventDescription: "Meet peers and build community.",
                tags: [category, idx % 2 == 0 ? "AI" : "Music"],
                isPromoted: idx % 5 == 0
            ))
        }

        try? context.save()
    }
}
