import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var profiles: [UserProfile]
    @Query private var events: [Event]
    @Query private var attendances: [Attendance]

    var body: some View {
        let profile = profiles.first ?? UserProfile()
        let planned = attendances.filter { $0.status == "going" }.count
        let score = RiskScoreService.score(stepsPerDay: profile.stepsPerDay, sleepHours: profile.sleepHours, plannedEvents: planned)
        let label = RiskScoreService.label(for: score)
        let drivers = RiskScoreService.drivers(stepsPerDay: profile.stepsPerDay, sleepHours: profile.sleepHours, plannedEvents: planned)
        let nextPlanned = events.filter { event in attendances.contains { $0.eventId == event.id && $0.status == "going" } }.sorted { $0.startDate < $1.startDate }.first

        return NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    CPCard {
                        HStack {
                            ScoreGaugeView(score: score)
                            VStack(alignment: .leading) {
                                Text("Isolation Risk: \(label)").font(Typography.headline)
                                ForEach(drivers, id: \.self) { Text("• \($0)").font(Typography.caption) }
                            }
                        }
                    }
                    CPCard {
                        VStack(alignment: .leading) {
                            Text("Next planned event").font(Typography.headline)
                            Text(nextPlanned?.title ?? "No event planned")
                            Text(nextPlanned?.startDate.formatted(date: .abbreviated, time: .shortened) ?? "Tap Discover to start")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}
