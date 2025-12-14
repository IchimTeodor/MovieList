import Foundation
import MovieBrowserDomain
import MovieBrowserService

@MainActor
package final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var detail: MovieDetail?
    @Published private(set) var contentState: ContentState = .idle
    @Published private(set) var extrasState: ExtrasState = .idle
    @Published var showTrailerPrompt = false
    @Published private(set) var playingTrailer: TrailerSource?
    @Published private(set) var isTrailerLoading = false

    private let movie: MovieSummary
    private let service: MovieServicing
    private let onNavigate: (MovieDetailDestination) -> Void

    var title: String {
        detail?.title ?? movie.title
    }

    var heroImageURL: URL? {
        detail?.bannerURL ?? movie.coverImageURL
    }

    var scoreDisplay: String? {
        detail?.imdbScoreText ?? movie.imdbScoreText
    }

    var isFavorite: Bool {
        detail?.isFavorite ?? false
    }

    var detailInfoItems: [DetailInfoItem] {
        guard case let .loaded(detail) = contentState else {
            return [
                DetailInfoItem(title: "Length", value: "—"),
                DetailInfoItem(title: "Language", value: "—"),
                DetailInfoItem(title: "Rating", value: "—")
            ]
        }
        return [
            DetailInfoItem(title: "Length", value: detail.length ?? "—"),
            DetailInfoItem(title: "Language", value: detail.language ?? "—"),
            DetailInfoItem(title: "Rating", value: detail.rating ?? "—")
        ]
    }

    var isLoading: Bool {
        if case .loading = contentState {
            return true
        }
        return false
    }

    var errorMessage: String? {
        if case let .failed(message) = contentState {
            return message
        }
        return nil
    }
    
    package init(
        movie: MovieSummary,
        service: MovieServicing,
        onNavigate: @escaping (MovieDetailDestination) -> Void
    ) {
        self.movie = movie
        self.service = service
        self.onNavigate = onNavigate
    }

    func trailerSource(for detail: MovieDetail) -> TrailerSource? {
        if let site = detail.trailerSite?.lowercased(),
           let id = detail.trailerVideoID,
           site == "youtube" {
            return .youtube(id: id)
        }
        if let direct = detail.trailerURL {
            return .direct(direct)
        }
        return nil
    }

    func loadIfNeeded() async {
        guard !isLoading, detail == nil else { return }
        await fetchDetails()
    }

    func refresh() async {
        await fetchDetails()
    }

    func dismiss() {
        onNavigate(.dismiss)
    }

    func retryExtras() async {
        guard case .loaded = contentState, extrasState != .loading else { return }
        await loadExtras()
    }

    func beginTrailerPlayback() {
        guard let detail, let source = trailerSource(for: detail) else { return }
        isTrailerLoading = true
        playingTrailer = source
    }

    func stopTrailerPlayback() {
        playingTrailer = nil
        isTrailerLoading = false
    }

    func markTrailerReady() {
        isTrailerLoading = false
    }

    private func fetchDetails() async {
        contentState = .loading
        do {
            extrasState = .idle
            let baseDetail = try await service.fetchDetailInfo(id: movie.id)
            detail = baseDetail
            contentState = .loaded(baseDetail)
        } catch {
            detail = nil
            contentState = .failed(error.localizedDescription)
        }
    }
    
    func loadExtras() async {
        extrasState = .loading
        do {
            let extras = try await service.fetchDetailExtras(id: movie.id)
            guard case let .loaded(currentDetail) = self.contentState else { return }
            let updated = currentDetail.mergingExtras(extras)
            self.detail = updated
            self.contentState = .loaded(updated)
            self.extrasState = .loaded
        } catch is CancellationError {
            // Ignore cancellation
        } catch {
            extrasState = .failed(error.localizedDescription)
        }
    }
}

package extension MovieDetailViewModel {
    enum ContentState: Equatable {
        case idle
        case loading
        case loaded(MovieDetail)
        case failed(String)
    }

    enum ExtrasState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }
}

package struct DetailInfoItem: Identifiable {
    package let id = UUID()
    let title: String
    let value: String
}
