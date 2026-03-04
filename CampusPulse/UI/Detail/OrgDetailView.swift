import SwiftUI
import SwiftData

struct OrgDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    let org: Organization

    var orgEvents: [Event] { events.filter { $0.orgName == org.name && $0.startDate > .now }.sorted { $0.startDate < $1.startDate } }

    var body: some View {
        List {
            Section("About") {
                Text(org.organizationDescription)
                if org.isPremium { Label("Premium Club Page", systemImage: "star.fill").foregroundStyle(ColorTokens.accent) }
            }
            Section("Upcoming Meetings") {
                ForEach(orgEvents) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                        Text(event.startDate.formatted(date: .abbreviated, time: .shortened)).font(.caption)
                    }
                }
            }
            if let next = orgEvents.first {
                Button("Add next meeting to plan") {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    modelContext.insert(Attendance(eventId: next.id, status: "going"))
                    try? modelContext.save()
                }
            }
        }
        .navigationTitle(org.name)
    }
}
