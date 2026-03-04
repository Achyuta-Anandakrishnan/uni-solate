import SwiftUI

struct ScoreGaugeView: View {
    let score: Int

    var body: some View {
        ZStack {
            Circle().stroke(Color.gray.opacity(0.2), lineWidth: 14)
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100)
                .stroke(ColorTokens.accent, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring, value: score)
            VStack {
                Text("\(score)").font(.system(size: 34, weight: .bold, design: .rounded))
                Text("Risk").font(Typography.caption)
            }
        }
        .frame(width: 140, height: 140)
    }
}
