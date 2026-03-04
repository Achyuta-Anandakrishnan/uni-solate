import SwiftUI
import SwiftData

struct OrgDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    let org: Organization

    private var orgEvents: [Event] {
        events
            .filter { $0.orgName == org.name && $0.startDate > .now }
            .sorted { $0.startDate < $1.startDate }
    }

    var body: some View {
        List {
            Section("About") {
                Text(org.organizationDescription)
                HStack {
                    if org.isVerified {
                        Label("Verified", systemImage: "checkmark.seal.fill").foregroundStyle(.green)
                    }
                    if org.isPremium {
                        Label("Premium Club Page", systemImage: "star.fill").foregroundStyle(ColorTokens.accent)
                    }
                }
            }

            if let next = orgEvents.first {
                Section("Next upcoming meeting") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(next.title).font(Typography.headline)
                        Text(next.startDate.formatted(date: .abbreviated, time: .shortened))
                            .font(Typography.caption)
                            .foregroundStyle(.secondary)
                        Button("Add next meeting to plan") {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            modelContext.insert(Attendance(eventId: next.id, status: "going"))
                            try? modelContext.save()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }

            Section("Future meetings") {
                ForEach(orgEvents) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                        Text(event.startDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(org.name)
    }
}
