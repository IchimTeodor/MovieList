import SwiftUI
import MovieBrowserDomain
import DesignSystem

struct MovieListRowView: View {
    let movie: MovieSummary

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            RemoteImageView(url: movie.coverImageURL, contentMode: .fill) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(DesignSystem.Colors.surfaceSecondary)
                    .overlay(ProgressView().tint(DesignSystem.Colors.brandPrimary))
            }
            .frame(width: 92, height: 132)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                    Text(movie.imdbScoreText)
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)

                if !movie.genres.isEmpty {
                    WrapView(data: movie.genres.prefix(3)) { genre in
                        Text(genre.uppercased())
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(DesignSystem.Colors.surfaceSecondary.opacity(0.3), in: Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(movie.subtitle)
                    .font(.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.mutedText)
        }
        .padding(.vertical, 10)
    }
}
