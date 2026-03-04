import SwiftUI
import SwiftData

struct DirectoryView: View {
    @Query private var organizations: [Organization]
    @Query private var events: [Event]

    @State private var query = ""
    @State private var mode = 0

    private var filteredOrgs: [Organization] {
        organizations
            .filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
            .sorted { $0.name < $1.name }
    }

    private var filteredEvents: [Event] {
        events
            .filter { query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) || $0.orgName.localizedCaseInsensitiveContains(query) }
            .sorted { $0.startDate < $1.startDate }
    }

    var body: some View {
        NavigationStack {
            List {
                Picker("Mode", selection: $mode) {
                    Text("Organizations").tag(0)
                    Text("Events").tag(1)
                }
                .pickerStyle(.segmented)

                if mode == 0 {
                    ForEach(filteredOrgs) { org in
                        NavigationLink {
                            OrgDetailView(org: org)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(org.name)
                                Text(org.category)
                                    .font(Typography.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } else {
                    ForEach(filteredEvents) { event in
                        NavigationLink {
                            EventDetailView(event: event)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                Text("\(event.orgName) • \(event.startDate.formatted(date: .abbreviated, time: .shortened))")
                                    .font(Typography.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .searchable(text: $query, prompt: "Search clubs or events")
            .navigationTitle("Directory")
        }
    }
}
