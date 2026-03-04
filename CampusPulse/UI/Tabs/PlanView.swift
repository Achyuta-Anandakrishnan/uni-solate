import SwiftUI
import SwiftData

struct PlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @Query private var attendances: [Attendance]

    var goingEvents: [Event] {
        let ids = Set(attendances.filter { $0.status == "going" }.map(\.eventId))
        return events.filter { ids.contains($0.id) }.sorted { $0.startDate < $1.startDate }
    }

    var body: some View {
        NavigationStack {
            List {
                if goingEvents.isEmpty {
                    EmptyStateView(title: "No planned events", subtitle: "Mark \"I'm going\" in Discover.", icon: "calendar.badge.plus")
                }
                ForEach(goingEvents) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                        Text(event.startDate.formatted(date: .abbreviated, time: .shortened)).font(.caption)
                    }
                    .swipeActions {
                        Button("Attended") {
                            attendances.first(where: { $0.eventId == event.id })?.status = "attended"
                            try? modelContext.save()
                        }.tint(.green)
                        Button("Remove", role: .destructive) {
                            if let a = attendances.first(where: { $0.eventId == event.id }) { modelContext.delete(a); try? modelContext.save() }
                        }
                    }
                }
            }
            .navigationTitle("Plan")
        }
    }
}
