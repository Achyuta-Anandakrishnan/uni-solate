import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var showICS = false

    var body: some View {
        NavigationStack {
            if let profile = profiles.first {
                Form {
                    Section("Lifestyle") {
                        Stepper("Steps: \(profile.stepsPerDay)", value: Binding(get: { profile.stepsPerDay }, set: { profile.stepsPerDay = $0 }), in: 1000...20000, step: 500)
                        VStack(alignment: .leading) {
                            Text("Sleep hours: \(profile.sleepHours, specifier: "%.1f")")
                            Slider(value: Binding(get: { profile.sleepHours }, set: { profile.sleepHours = $0 }), in: 4...10, step: 0.5)
                        }
                    }

                    Section("Preferences") {
                        Toggle("Include nearby schools", isOn: Binding(get: { profile.includeNearbySchools }, set: { profile.includeNearbySchools = $0 }))
                        NavigationLink("Edit interests") {
                            InterestsEditorView(selected: Binding(get: { profile.interests }, set: { profile.interests = $0 }))
                        }
                    }

                    Section("Schedule") {
                        Button("Re-import ICS schedule") { showICS = true }
                    }
                }
                .navigationTitle("Profile")
                .sheet(isPresented: $showICS) { ICSImportView() }
                .onDisappear { try? modelContext.save() }
            } else {
                EmptyStateView(title: "No profile", subtitle: "Complete onboarding to continue.", icon: "person.crop.circle.badge.exclamationmark")
            }
        }
    }
}

struct InterestsEditorView: View {
    @Binding var selected: [String]

    var body: some View {
        InterestsView(selected: $selected)
            .navigationTitle("Interests")
            .navigationBarTitleDisplayMode(.inline)
    }
}
