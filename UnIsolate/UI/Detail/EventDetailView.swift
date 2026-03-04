import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var attendances: [Attendance]
    let event: Event

    var attendance: Attendance? { attendances.first { $0.eventId == event.id } }

    var body: some View {
        ScrollView {
            CPCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text(event.title).font(Typography.title)
                    Text(event.eventDescription)
                    Text(event.location).foregroundStyle(.secondary)
                    HStack {
                        Button("I'm going") { toggleGoing() }
                        Button("Want buddy") { toggleBuddy() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }.padding()
    }

    private func toggleGoing() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if let attendance { attendance.status = attendance.status == "going" ? "none" : "going" }
        else { modelContext.insert(Attendance(eventId: event.id, status: "going")) }
        try? modelContext.save()
    }

    private func toggleBuddy() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        if let attendance {
            attendance.wantsBuddy.toggle()
            attendance.buddyGroupCount = attendance.wantsBuddy ? max(1, attendance.buddyGroupCount + 1) : 0
        } else {
            modelContext.insert(Attendance(eventId: event.id, status: "going", wantsBuddy: true, buddyGroupCount: 1))
        }
        try? modelContext.save()
    }
}
