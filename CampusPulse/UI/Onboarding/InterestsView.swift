import SwiftUI

struct InterestsView: View {
    @Binding var selected: [String]
    let interests = ["Robotics","Entrepreneurship","Fitness","Volunteering","AI","Gaming","Sales","Startups","Outdoor","Music","Engineering","Business"]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(interests, id: \.self) { interest in
                ChipView(title: interest, selected: selected.contains(interest))
                    .onTapGesture {
                        if selected.contains(interest) { selected.removeAll { $0 == interest } }
                        else { selected.append(interest) }
                    }
            }
        }
    }
}

struct FlowLayout<Content: View>: View {
    var spacing: CGFloat
    @ViewBuilder var content: Content
    var body: some View { content }
}
