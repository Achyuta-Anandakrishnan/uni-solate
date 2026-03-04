import SwiftUI

struct ChipView: View {
    let title: String
    var selected: Bool

    var body: some View {
        Text(title)
            .font(Typography.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(selected ? ColorTokens.accent.opacity(0.2) : ColorTokens.elevated)
            .foregroundStyle(selected ? ColorTokens.accent : .primary)
            .clipShape(Capsule())
    }
}
