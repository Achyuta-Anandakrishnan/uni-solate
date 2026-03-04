import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Query private var events: [Event]
    @Query private var busyBlocks: [BusyBlock]
    @Query private var profiles: [UserProfile]

    @State private var filter = "Schedule-fit"
    let filters = ["Schedule-fit", "Social", "Active", "Promoted", "Soonest"]

    var body: some View {
        let profile = profiles.first ?? UserProfile()
        let risk = RiskScoreService.score(stepsPerDay: profile.stepsPerDay, sleepHours: profile.sleepHours, plannedEvents: 0)
        let windows = FreeTimeService.freeWindows(for: busyBlocks)
        var recs = RecommendationService.recommend(events: events, profile: profile, windows: windows, riskScore: risk)

        if filter == "Social" { recs = recs.filter { $0.event.category == "Social" } }
        if filter == "Active" { recs = recs.filter { $0.event.category == "Active" } }
        if filter == "Promoted" { recs = recs.filter { $0.event.isPromoted } }
        if filter == "Soonest" { recs = recs.sorted { $0.event.startDate < $1.event.startDate } }

        return NavigationStack {
            ScrollView {
                Picker("Filter", selection: $filter) { ForEach(filters, id: \.self) { Text($0) } }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 8)

                ForEach(recs) { rec in
                    NavigationLink {
                        EventDetailView(event: rec.event)
                    } label: {
                        CPCard {
                            VStack(alignment: .leading) {
                                Text(rec.event.title).font(Typography.headline)
                                Text(rec.event.orgName).foregroundStyle(.secondary)
                                Text(rec.event.startDate.formatted(date: .abbreviated, time: .shortened))
                                Text(rec.event.location).font(Typography.caption)
                                Text(rec.reason).font(Typography.caption).foregroundStyle(ColorTokens.accent)
                            }
                        }
                    }.buttonStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Discover")
        }
    }
}
