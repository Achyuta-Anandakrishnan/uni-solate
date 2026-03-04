import SwiftUI
import SwiftData

struct OnboardingFlowView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var step = 0
    @Namespace private var namespace

    @State private var school = "NC State"
    @State private var email = ""
    @State private var interests: [String] = []
    @State private var steps = 5000
    @State private var sleep = 7.0
    @State private var includeNearbySchools = false
    @State private var involvement = 0
    @State private var connection = 50
    @State private var currentlyInOrg = false
    @State private var wantsNewPeople = true

    var done: () -> Void

    private let totalSteps = 6

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ProgressView(value: Double(step + 1), total: Double(totalSteps + 1))
                    .tint(ColorTokens.accent)
                    .padding(.horizontal)

                TabView(selection: $step) {
                    welcome.tag(0)
                    SchoolEmailView(school: $school, email: $email).tag(1)
                    ICSImportView().padding().tag(2)
                    InterestsView(selected: $interests).tag(3)
                    LifestyleView(steps: $steps, sleep: $sleep, includeNearbySchools: $includeNearbySchools).tag(4)
                    IsolationSurveyView(involvement: $involvement, connection: $connection, currentlyInOrg: $currentlyInOrg, wantsNewPeople: $wantsNewPeople).tag(5)
                    finish.tag(6)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack {
                    if step > 0 {
                        Button("Back") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { step -= 1 }
                        }
                        .buttonStyle(.bordered)
                    }

                    Spacer()

                    Button(step == totalSteps ? "Go to Dashboard" : "Continue") {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        if step < totalSteps {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { step += 1 }
                        } else {
                            finishOnboarding()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .matchedGeometryEffect(id: "onboarding_cta", in: namespace)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            .background(ColorTokens.background)
        }
    }

    private var welcome: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "person.3.sequence.fill")
                .font(.system(size: 64))
                .foregroundStyle(ColorTokens.accent)
            Text("Welcome to un-isolate")
                .font(Typography.title)
            Text("un-isolate helps students find organizations and events that match their schedule and interests.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            Spacer()
        }
        .padding()
    }

    private var finish: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            Text("You're ready")
                .font(Typography.title)
            Text("We'll personalize your dashboard and recommendations from your schedule, interests, and lifestyle signals.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            Spacer()
        }
    }

    private func finishOnboarding() {
        let profile = profiles.first ?? UserProfile()
        profile.email = email
        profile.school = school
        profile.interests = interests
        profile.stepsPerDay = steps
        profile.sleepHours = sleep
        profile.includeNearbySchools = includeNearbySchools
        profile.involvementLevel = involvement + (currentlyInOrg ? 2 : 0) + (wantsNewPeople ? 1 : 0)
        profile.connectionScore = connection
        profile.hasCompletedOnboarding = true

        if profiles.isEmpty {
            modelContext.insert(profile)
        }

        try? modelContext.save()
        done()
    }
}
