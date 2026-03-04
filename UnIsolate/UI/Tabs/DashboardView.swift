import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var profiles: [UserProfile]
    @Query private var events: [Event]
    @Query private var attendances: [Attendance]
    @Query private var busyBlocks: [BusyBlock]

    var body: some View {
        let profile = profiles.first ?? UserProfile()
        let plannedAttendances = attendances.filter { $0.status == "going" }
        let plannedCount = plannedAttendances.count
        let score = RiskScoreService.score(stepsPerDay: profile.stepsPerDay, sleepHours: profile.sleepHours, plannedEvents: plannedCount)
        let label = RiskScoreService.label(for: score)
        let drivers = RiskScoreService.drivers(stepsPerDay: profile.stepsPerDay, sleepHours: profile.sleepHours, plannedEvents: plannedCount)
        let nextPlanned = events
            .filter { event in plannedAttendances.contains { $0.eventId == event.id } }
            .sorted { $0.startDate < $1.startDate }
            .first
        let rec = RecommendationService.recommend(events: events, profile: profile, windows: FreeTimeService.freeWindows(for: busyBlocks), riskScore: score).first

        return NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    CPCard {
                        HStack(spacing: 16) {
                            ScoreGaugeView(score: score)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Isolation Risk: \(label)").font(Typography.headline)
                                ForEach(drivers, id: \.self) { Text("• \($0)").font(Typography.caption) }
                            }
                        }
                    }

                    CPCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Next planned event").font(Typography.headline)
                            Text(nextPlanned?.title ?? "No event planned")
                            Text(nextPlanned?.startDate.formatted(date: .abbreviated, time: .shortened) ?? "Tap Discover to start")
                                .foregroundStyle(.secondary)
                        }
                    }

                    CPCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Recommended upcoming meeting").font(Typography.headline)
                            Text(rec?.event.title ?? "No recommendations yet")
                            Text(rec?.closestMeetingText ?? "Import schedule to improve matching")
                                .foregroundStyle(.secondary)
                        }
                    }

                    NavigationLink {
                        DiscoverView()
                    } label: {
                        Label("Open Discover", systemImage: "sparkles")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}
