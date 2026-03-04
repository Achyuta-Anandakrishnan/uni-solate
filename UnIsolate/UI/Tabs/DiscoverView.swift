import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @Query private var busyBlocks: [BusyBlock]
    @Query private var profiles: [UserProfile]
    @Query private var attendances: [Attendance]

    @State private var filter = "Schedule-fit"
    private let filters = ["Schedule-fit", "Social", "Active", "Promoted", "Soonest"]

    var body: some View {
        let profile = profiles.first ?? UserProfile()
        let risk = RiskScoreService.score(stepsPerDay: profile.stepsPerDay, sleepHours: profile.sleepHours, plannedEvents: attendances.filter { $0.status == "going" }.count)
        let windows = FreeTimeService.freeWindows(for: busyBlocks)
        var recs = RecommendationService.recommend(events: events, profile: profile, windows: windows, riskScore: risk)

        if filter == "Social" { recs = recs.filter { $0.event.category == "Social" } }
        if filter == "Active" { recs = recs.filter { $0.event.category == "Active" } }
        if filter == "Promoted" { recs = recs.filter { $0.event.isPromoted } }
        if filter == "Soonest" { recs = recs.sorted { $0.event.startDate < $1.event.startDate } }

        return NavigationStack {
            ScrollView {
                Picker("Filter", selection: $filter) {
                    ForEach(filters, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 8)

                if recs.isEmpty {
                    EmptyStateView(title: "No schedule-fit events", subtitle: "Try importing your ICS schedule or broadening filters.", icon: "calendar.badge.exclamationmark")
                }

                ForEach(recs) { rec in
                    CPCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(rec.event.title).font(Typography.headline)
                                Spacer()
                                if rec.event.isPromoted {
                                    Label("Promoted", systemImage: "megaphone.fill")
                                        .font(Typography.caption)
                                        .foregroundStyle(ColorTokens.accent)
                                }
                            }

                            Text(rec.event.orgName).foregroundStyle(.secondary)
                            Text(rec.closestMeetingText).font(Typography.caption)
                            Text(rec.event.location).font(Typography.caption)
                            Text("Why recommended: \(rec.whyRecommended)")
                                .font(Typography.caption)
                                .foregroundStyle(ColorTokens.accent)

                            HStack {
                                Button("I'm going") { toggleGoing(eventID: rec.event.id) }
                                    .buttonStyle(.borderedProminent)
                                Button("Want buddy") { toggleBuddy(eventID: rec.event.id) }
                                    .buttonStyle(.bordered)
                                Spacer()
                                NavigationLink("Details") { EventDetailView(event: rec.event) }
                                    .font(Typography.caption)
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Discover")
        }
    }

    private func toggleGoing(eventID: UUID) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if let attendance = attendances.first(where: { $0.eventId == eventID }) {
            attendance.status = attendance.status == "going" ? "none" : "going"
            attendance.updatedAt = .now
        } else {
            modelContext.insert(Attendance(eventId: eventID, status: "going"))
        }
        try? modelContext.save()
    }

    private func toggleBuddy(eventID: UUID) {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        if let attendance = attendances.first(where: { $0.eventId == eventID }) {
            attendance.wantsBuddy.toggle()
            attendance.buddyGroupCount = attendance.wantsBuddy ? max(attendance.buddyGroupCount + 1, 1) : 0
            attendance.updatedAt = .now
        } else {
            modelContext.insert(Attendance(eventId: eventID, status: "going", wantsBuddy: true, buddyGroupCount: 1))
        }
        try? modelContext.save()
    }
}
