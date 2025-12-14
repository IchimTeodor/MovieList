import SwiftUI
import MovieBrowserDomain
import DesignSystem

struct MovieCardView: View {
    let movie: MovieSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RemoteImageView(url: movie.coverImageURL, contentMode: .fill) {
                Rectangle()
                    .fill(DesignSystem.Colors.surfaceSecondary)
                    .overlay(ProgressView().tint(DesignSystem.Colors.brandPrimary))
            }
            .frame(width: 200, height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 10, y: 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)

                Text(movie.subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                    Text(movie.imdbScoreText)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }
                .padding(.top, 4)
            }
        }
        .frame(width: 200, height: 320, alignment: .topLeading)
    }
}
