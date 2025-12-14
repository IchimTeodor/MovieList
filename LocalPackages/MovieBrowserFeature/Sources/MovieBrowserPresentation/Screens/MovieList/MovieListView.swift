import SwiftUI
import MovieBrowserDomain
import DesignSystem
package struct MovieListView: View {
    @StateObject private var viewModel: MovieListViewModel
    private let heroSplitCount = 6
    @State private var selectedTab: Tab = .discover

    package init(viewModel: MovieListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    package var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            TabView(selection: $selectedTab) {
                discoverContent
                    .tabItem { Label("Discover", systemImage: "film") }
                    .tag(Tab.discover)
                favoritesContent
                    .tabItem { Label("Favourites", systemImage: "heart") }
                    .tag(Tab.favorites)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.white, for: .tabBar)
        }
        .navigationTitle("FilmKu")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {}) {
                    iconButton(systemName: "line.3.horizontal")
                }
                .buttonStyle(.plain)
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {}) {
                    iconButton(systemName: "bell.badge")
                }
                .buttonStyle(.plain)
                Button(action: {}) {
                    iconButton(systemName: "magnifyingglass")
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var discoverContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DesignSystem.Layout.sectionSpacing) {
                header(
                    title: "Hand picked AniList cinema",
                    subtitle: "Browse a curated feed of anime movies powered by GraphQL details."
                )
                discoverSections
            }
            .padding(.horizontal, DesignSystem.Layout.screenPadding)
            .padding(.vertical, 24)
        }
        .background(Color.white)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.loadInitialIfNeeded()
        }
    }

    private var favoritesContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DesignSystem.Layout.sectionSpacing) {
                header(
                    title: "Favourites",
                    subtitle: "Your bookmarked anime films."
                )
                if viewModel.favoriteMovies.isEmpty {
                    Text("You haven't added any favourites yet.")
                        .font(.callout)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 60)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.favoriteMovies) { movie in
                            MovieListRowView(movie: movie)
                                .onTapGesture { viewModel.didSelect(movie: movie) }
                        }
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Layout.screenPadding)
            .padding(.vertical, 24)
        }
        .background(Color.white)
    }

    @ViewBuilder
    private var discoverSections: some View {
        if viewModel.isInitialLoading && viewModel.movies.isEmpty {
            loadingState
        } else if let message = viewModel.errorMessage, viewModel.movies.isEmpty {
            errorState(message: message)
        } else {
            nowShowingSection
            if !popularMovies.isEmpty {
                popularSection
            }
            asyncStateFooter
        }
    }

    private var loadingState: some View {
        VStack(spacing: 12) {
            ProgressView("Loading movies…")
                .tint(DesignSystem.Colors.brandPrimary)
            Text("Fetching fresh titles from AniList")
                .font(.footnote)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 260)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardCornerRadius)
                .fill(DesignSystem.Colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardCornerRadius)
                .stroke(DesignSystem.Colors.cardBorder)
        )
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Button {
                Task { await viewModel.retry() }
            } label: {
                Text("Retry")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(DesignSystem.Colors.brandPrimary.opacity(0.15), in: Capsule())
            }
        }
        .frame(maxWidth: .infinity, minHeight: 280)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardCornerRadius)
                .fill(DesignSystem.Colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardCornerRadius)
                .stroke(DesignSystem.Colors.cardBorder)
        )
    }

    private var nowShowingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Now Showing", action: triggerPagination)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(nowShowingMovies) { movie in
                        MovieCardView(movie: movie)
                            .frame(width: 220)
                            .onTapGesture { viewModel.didSelect(movie: movie) }
                            .onAppear {
                                Task { await viewModel.loadMoreIfNeeded(for: movie) }
                            }
                    }
                }
                .padding(.horizontal, 4)
            }
            .scrollClipDisabled()
        }
    }

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Popular", action: triggerPagination)
            LazyVStack(spacing: 16) {
                ForEach(popularMovies) { movie in
                    MovieListRowView(movie: movie)
                        .onTapGesture { viewModel.didSelect(movie: movie) }
                        .onAppear {
                            Task { await viewModel.loadMoreIfNeeded(for: movie) }
                        }
                }
            }
        }
    }

    @ViewBuilder
    private var asyncStateFooter: some View {
        if viewModel.isPaginating {
            HStack(spacing: 10) {
                ProgressView()
                    .tint(DesignSystem.Colors.brandPrimary)
                Text("Loading more films…")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
        } else if let message = viewModel.errorMessage {
            InlineErrorView(message: message) {
                Task { await viewModel.retry() }
            }
        }
    }

    private var nowShowingMovies: [MovieSummary] {
        Array(viewModel.movies.prefix(heroSplitCount))
    }

    private var popularMovies: [MovieSummary] {
        Array(viewModel.movies.dropFirst(min(heroSplitCount, viewModel.movies.count)))
    }

    private func sectionHeader(title: String, action: (() -> Void)? = nil) -> some View {
        HStack {
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Spacer()
            if let action {
                Button(action: action) {
                    Text("See more")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .overlay(
                            Capsule()
                                .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func iconButton(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.body.weight(.semibold))
            .foregroundStyle(DesignSystem.Colors.brandPrimary)
            .frame(width: 38, height: 38)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(DesignSystem.Colors.surface)
                    .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
            )
    }

    private func triggerPagination() {
        guard let lastMovie = viewModel.movies.last else { return }
        Task {
            await viewModel.loadMoreIfNeeded(for: lastMovie)
        }
    }

    private func header(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            Text(subtitle)
                .font(.callout)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
    }

    private enum Tab: Hashable {
        case discover
        case favorites
    }
}
