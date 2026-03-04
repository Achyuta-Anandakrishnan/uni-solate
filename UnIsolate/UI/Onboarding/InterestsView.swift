import SwiftUI

struct InterestsView: View {
    @Binding var selected: [String]

    private let interests = ["Robotics", "Entrepreneurship", "Fitness", "Volunteering", "AI", "Gaming", "Sales", "Startups", "Outdoor", "Music", "Engineering", "Business"]
    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 8)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Choose your interests")
                    .font(Typography.title)
                Text("Used to personalize recommendations.")
                    .font(Typography.body)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(interests, id: \.self) { interest in
                        ChipView(title: interest, selected: selected.contains(interest))
                            .onTapGesture {
                                if selected.contains(interest) {
                                    selected.removeAll { $0 == interest }
                                } else {
                                    selected.append(interest)
                                }
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                    }
                }
            }
            .padding()
        }
    }
}
