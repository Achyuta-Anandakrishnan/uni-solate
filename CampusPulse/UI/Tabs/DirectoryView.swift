import SwiftUI
import SwiftData

struct DirectoryView: View {
    @Query private var organizations: [Organization]
    @Query private var events: [Event]
    @State private var query = ""
    @State private var mode = 0

    var body: some View {
        NavigationStack {
            List {
                Picker("Mode", selection: $mode) {
                    Text("Organizations").tag(0)
                    Text("Events").tag(1)
                }
                .pickerStyle(.segmented)

                if mode == 0 {
                    ForEach(organizations.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }) { org in
                        NavigationLink(org.name) { OrgDetailView(org: org) }
                    }
                } else {
                    ForEach(events.filter { query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) }) { event in
                        NavigationLink(event.title) { EventDetailView(event: event) }
                    }
                }
            }
            .searchable(text: $query, prompt: "Search clubs or events")
            .navigationTitle("Directory")
        }
    }
}
