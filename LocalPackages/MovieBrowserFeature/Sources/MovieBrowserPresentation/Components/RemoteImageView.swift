import SwiftUI
import DesignSystem

struct RemoteImageView<Placeholder: View>: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    @ViewBuilder var placeholder: () -> Placeholder

    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut(duration: 0.2))
        ) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity)
            case .failure:
                placeholder()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                ZStack {
                    placeholder()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .redacted(reason: .placeholder)
                    ProgressView()
                        .tint(DesignSystem.Colors.brandPrimary)
                }
            @unknown default:
                placeholder()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .clipped()
    }
}
