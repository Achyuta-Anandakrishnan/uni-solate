import SwiftUI

struct IsolationSurveyView: View {
    @Binding var involvement: Int
    @Binding var connection: Int

    var body: some View {
        Form {
            Stepper("Campus events attended last week: \(involvement)", value: $involvement, in: 0...10)
            VStack(alignment: .leading) {
                Text("How connected do you feel on campus? \(connection)/100")
                Slider(value: Binding(get: { Double(connection) }, set: { connection = Int($0) }), in: 0...100, step: 1)
            }
            Toggle("Are you currently in any organizations?", isOn: .constant(false)).disabled(true)
            Toggle("Do you want to meet new people this semester?", isOn: .constant(true)).disabled(true)
        }
        .scrollContentBackground(.hidden)
    }
}
