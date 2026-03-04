import SwiftUI

struct CPCard<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var pressed = false

    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: ColorTokens.shadow, radius: 10, y: 5)
            .scaleEffect(pressed ? 0.98 : 1)
            .animation(.spring(response: 0.25), value: pressed)
            .onLongPressGesture(minimumDuration: 0.05, pressing: { pressing in
                pressed = pressing
            }, perform: {})
    }
}
