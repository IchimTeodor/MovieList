import SwiftUI
import DesignSystem

struct InlineErrorView: View {
    let message: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.footnote)
                .foregroundStyle(DesignSystem.Colors.warningForeground)
                .multilineTextAlignment(.center)
            Button("Try again", action: action)
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(DesignSystem.Colors.warningForeground.opacity(0.15), in: Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(DesignSystem.Colors.warningBackground, in: RoundedRectangle(cornerRadius: 18))
    }
}
