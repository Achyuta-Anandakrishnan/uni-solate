import SwiftUI

struct IsolationSurveyView: View {
    @Binding var involvement: Int
    @Binding var connection: Int
    @Binding var currentlyInOrg: Bool
    @Binding var wantsNewPeople: Bool

    var body: some View {
        Form {
            Section("Isolation check") {
                Stepper("Campus events attended last week: \(involvement)", value: $involvement, in: 0...10)
                Toggle("Are you currently in any organizations?", isOn: $currentlyInOrg)
                Toggle("Do you want to meet new people this semester?", isOn: $wantsNewPeople)
            }

            Section("How connected do you feel?") {
                VStack(alignment: .leading) {
                    Text("\(connection)/100")
                    Slider(value: Binding(get: { Double(connection) }, set: { connection = Int($0) }), in: 0...100, step: 1)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}
