import SwiftUI
import SwiftData

struct OnboardingFlowView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var step = 0
    @Namespace private var ns
    @State private var school = "NC State"
    @State private var email = ""
    @State private var interests: [String] = []
    @State private var steps = 5000
    @State private var sleep = 7.0
    @State private var involvement = 0
    @State private var connection = 50

    var done: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $step) {
                    welcome.tag(0)
                    SchoolEmailView(school: $school, email: $email).tag(1)
                    ICSImportView().tag(2)
                    InterestsView(selected: $interests).padding().tag(3)
                    LifestyleView(steps: $steps, sleep: $sleep).tag(4)
                    IsolationSurveyView(involvement: $involvement, connection: $connection).tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                Button(step == 5 ? "Finish" : "Continue") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    if step < 5 { withAnimation(.spring) { step += 1 } } else { finishOnboarding() }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .matchedGeometryEffect(id: "cta", in: ns)
            }
            .background(ColorTokens.background)
        }
    }

    private var welcome: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.sequence.fill").font(.system(size: 56)).foregroundStyle(ColorTokens.accent)
            Text("Welcome to CampusPulse").font(Typography.title)
            Text("Find organizations and events that match your schedule and interests.").multilineTextAlignment(.center)
        }
        .padding()
    }

    private func finishOnboarding() {
        let profile = profiles.first ?? UserProfile()
        profile.email = email
        profile.school = school
        profile.interests = interests
        profile.stepsPerDay = steps
        profile.sleepHours = sleep
        profile.involvementLevel = involvement
        profile.connectionScore = connection
        profile.hasCompletedOnboarding = true
        if profiles.isEmpty { modelContext.insert(profile) }
        try? modelContext.save()
        done()
    }
}
