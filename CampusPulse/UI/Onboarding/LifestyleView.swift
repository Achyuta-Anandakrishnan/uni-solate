import SwiftUI

struct LifestyleView: View {
    @Binding var steps: Int
    @Binding var sleep: Double

    var body: some View {
        Form {
            Stepper("Steps per day: \(steps)", value: $steps, in: 1000...20000, step: 500)
            VStack(alignment: .leading) {
                Text("Sleep hours: \(sleep, specifier: "%.1f")")
                Slider(value: $sleep, in: 4...10, step: 0.5)
            }
            Toggle("Connect Apple Health (coming soon)", isOn: .constant(false)).disabled(true)
        }
        .scrollContentBackground(.hidden)
    }
}
