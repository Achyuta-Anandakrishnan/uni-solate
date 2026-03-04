import SwiftUI
import SwiftData

@main
struct CampusPulseApp: App {
    var container: ModelContainer = {
        let schema = Schema([UserProfile.self, BusyBlock.self, Organization.self, Event.self, Attendance.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    var body: some View {
        Group {
            if profiles.first?.hasCompletedOnboarding == true {
                MainTabView()
            } else {
                OnboardingFlowView { }
            }
        }
        .onAppear { SeedService.seedIfNeeded(context: modelContext) }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView().tabItem { Label("Dashboard", systemImage: "gauge") }
            PlanView().tabItem { Label("Plan", systemImage: "calendar") }
            DiscoverView().tabItem { Label("Discover", systemImage: "sparkles") }
            DirectoryView().tabItem { Label("Directory", systemImage: "magnifyingglass") }
            ProfileView().tabItem { Label("Profile", systemImage: "person") }
        }
        .tint(ColorTokens.accent)
    }
}
