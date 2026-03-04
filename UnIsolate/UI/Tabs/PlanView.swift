import SwiftUI
import SwiftData

struct PlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @Query private var attendances: [Attendance]

    @State private var selectedDay: Date = .now

    private var weekDates: [Date] {
        let calendar = Calendar.current
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    private var goingEvents: [Event] {
        let ids = Set(attendances.filter { $0.status == "going" }.map(\.eventId))
        return events.filter { ids.contains($0.id) }.sorted { $0.startDate < $1.startDate }
    }

    private var dayEvents: [Event] {
        let cal = Calendar.current
        return goingEvents.filter { cal.isDate($0.startDate, inSameDayAs: selectedDay) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(weekDates, id: \.self) { day in
                                VStack {
                                    Text(day.formatted(.dateTime.weekday(.abbreviated)))
                                    Text(day.formatted(.dateTime.day()))
                                }
                                .font(Typography.caption)
                                .padding(.vertical, 8)
                                .frame(width: 56)
                                .background(Calendar.current.isDate(day, inSameDayAs: selectedDay) ? ColorTokens.accent.opacity(0.2) : ColorTokens.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .onTapGesture {
                                    withAnimation(.spring) { selectedDay = day }
                                }
                            }
                        }
                    }
                }

                if dayEvents.isEmpty {
                    EmptyStateView(title: "No events for this day", subtitle: "Pick another date or add events from Discover.", icon: "calendar.badge.plus")
                }

                ForEach(dayEvents) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                        Text(event.startDate.formatted(date: .omitted, time: .shortened)).font(.caption)
                    }
                    .swipeActions {
                        Button("Attended") {
                            attendances.first(where: { $0.eventId == event.id })?.status = "attended"
                            try? modelContext.save()
                        }.tint(.green)

                        Button("Remove", role: .destructive) {
                            if let attendance = attendances.first(where: { $0.eventId == event.id }) {
                                modelContext.delete(attendance)
                                try? modelContext.save()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Plan")
        }
    }
}
