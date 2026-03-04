import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon).font(.largeTitle).foregroundStyle(ColorTokens.accent)
            Text(title).font(Typography.headline)
            Text(subtitle).font(Typography.body).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .padding()
    }
}
