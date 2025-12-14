import SwiftUI
import MovieBrowserDomain
import DesignSystem
package struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    package init(viewModel: MovieDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var heroTrailerSource: TrailerSource? {
        guard let detail = viewModel.detail else { return nil }
        return viewModel.trailerSource(for: detail)
    }

    package var body: some View {
        Group {
            if let detail = viewModel.detail {
                detailScrollView(detail: detail)
            } else if let message = viewModel.errorMessage {
                blockingErrorView(message: message)
            } else {
                preloadView
            }
        }
        .background(Color.white.ignoresSafeArea())
    }

    private func detailScrollView(detail: MovieDetail) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: -80) {
                imageHero
                detailContent(detail: detail)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    CircleIconButton(
                        systemName: viewModel.isFavorite ? "heart.fill" : "heart",
                        foreground: .white,
                        background: Color.black.opacity(0.4)
                    )
                    CircleIconButton(systemName: "square.and.arrow.up")
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    private var preloadView: some View {
        VStack(spacing: 12) {
            ProgressView("Fetching details…")
                .tint(DesignSystem.Colors.brandPrimary)
            Text("Loading movie data from AniList")
                .font(.footnote)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    private func blockingErrorView(message: String) -> some View {
        VStack {
            InlineErrorView(message: message) {
                Task { await viewModel.refresh() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }

    private var imageHero: some View {
        heroContent
            .frame(maxWidth: .infinity)
            .frame(height: 360)
            .clipped()
    }

    @ViewBuilder
    private var heroContent: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .topTrailing) {
                if let playing = viewModel.playingTrailer {
                    TrailerPlayerView(source: playing, onReady: {
                        viewModel.markTrailerReady()
                    })
                    .frame(width: size.width, height: size.height)
                    .background(Color.black)

                    Button {
                        viewModel.stopTrailerPlayback()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding(12)
                    }

                    if viewModel.isTrailerLoading {
                        Color.black.opacity(0.35)
                            .overlay(ProgressView().tint(.white))
                            .frame(width: size.width, height: size.height)
                    }
                } else {
                    RemoteImageView(url: viewModel.heroImageURL, contentMode: .fill) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [DesignSystem.Colors.brandPrimary, DesignSystem.Colors.brandSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .overlay(
                        VStack {
                            Spacer()
                            if heroTrailerSource != nil {
                                playTrailerButton
                                    .padding(.bottom, 96)
                            }
                        }
                    )
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.65), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                        .allowsHitTesting(false)
                    )
                }
            }
        }
    }

    private var playTrailerButton: some View {
        Button {
            viewModel.beginTrailerPlayback()
        } label: {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [DesignSystem.Colors.brandPrimary, DesignSystem.Colors.brandSecondary], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 72, height: 72)
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 6)
                    Image(systemName: "play.fill")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }
                Text("Play Trailer")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .disabled(heroTrailerSource == nil)
        .opacity(heroTrailerSource == nil ? 0.6 : 1)
    }

    private func detailContent(detail: MovieDetail) -> some View {
        detailCard(detail: detail)
    }

    private func detailCard(detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            titleRow
            detailInfoGrid(items: viewModel.detailInfoItems)
            if !detail.genres.isEmpty {
                genreWrap(genres: detail.genres)
            }
            descriptionSection(detail: detail)
            castSection(detail: detail)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(DesignSystem.Colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(DesignSystem.Colors.cardBorder)
        )
        .shadow(color: Color(.sRGB, red: 0.18, green: 0.17, blue: 0.45, opacity: 0.12), radius: 18, y: 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var titleRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                if let subtitle = viewModel.scoreDisplay {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                        Text(subtitle)
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                }
            }
            Spacer()
            CircleIconButton(
                systemName: "ellipsis",
                foreground: DesignSystem.Colors.brandPrimary,
                background: DesignSystem.Colors.surfaceSecondary
            ) {}
        }
    }

    private func detailInfoGrid(items: [DetailInfoItem]) -> some View {
        HStack(alignment: .top, spacing: 24) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.textSecondary.opacity(0.7))
                    Text(item.value)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func genreWrap(genres: [String]) -> some View {
        WrapView(data: genres, spacing: 6, lineSpacing: 6) { genre in
            Text(genre.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(DesignSystem.Colors.surfaceSecondary.opacity(0.3), in: Capsule())
                .overlay(
                    Capsule().stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
                )
        }
    }

    private func descriptionSection(detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "Description")
            Text(detail.synopsis)
                .font(.body)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.leading)
        }
    }

    private func castSection(detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Cast", actionTitle: detail.cast.count > 4 ? "See more" : nil)
            castBody(for: detail)
        }
    }

    @ViewBuilder
    private func castBody(for detail: MovieDetail) -> some View {
        switch viewModel.extrasState {
        case .idle, .loading:
            extrasLoadingPlaceholder
                .task {
                    await viewModel.loadExtras()
                }
        case let .failed(message):
            InlineErrorView(message: message) {
                Task {
                    await viewModel.retryExtras()
                }
            }
        case .loaded:
            if detail.cast.isEmpty {
                emptyCastPlaceholder
            } else {
                castScroller(cast: detail.cast)
            }
        }
    }

    private func castScroller(cast: [MovieCastMember]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(cast) { member in
                    CastCardView(member: member)
                }
            }
        }
    }

    private var emptyCastPlaceholder: some View {
        Text("Cast details will appear once AniList exposes them for this title.")
            .font(.caption)
            .foregroundStyle(DesignSystem.Colors.textSecondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DesignSystem.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var extrasLoadingPlaceholder: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(DesignSystem.Colors.brandPrimary)
            Text("Fetching cast details…")
                .font(.footnote)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(DesignSystem.Colors.surfaceSecondary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func sectionHeader(title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Spacer()
            if let actionTitle {
                Button(action: action ?? {}) {
                    Text(actionTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.brandPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(DesignSystem.Colors.surfaceSecondary, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct CircleIconButton: View {
    var systemName: String
    var foreground: Color = .white
    var background: Color = .black.opacity(0.35)
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: action ?? {}) {
            Image(systemName: systemName)
                .font(.body.weight(.semibold))
                .foregroundStyle(foreground)
                .frame(width: 36, height: 36)
                .background(background, in: Circle())
        }
        .buttonStyle(.plain)
    }
}

private struct CastCardView: View {
    let member: MovieCastMember

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImageView(url: member.imageURL, contentMode: .fill) {
                Rectangle()
                    .fill(DesignSystem.Colors.surfaceSecondary)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(DesignSystem.Colors.brandPrimary)
                    )
            }
            .frame(width: 120, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            Text(member.name)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
                .lineLimit(2)
            if let role = member.role {
                Text(role.capitalized)
                    .font(.caption2)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
            if let voice = member.voiceActor {
                Text("VA: \(voice)")
                    .font(.caption2)
                    .foregroundStyle(DesignSystem.Colors.brandPrimary)
            }
        }
        .frame(width: 120, alignment: .leading)
    }
}
