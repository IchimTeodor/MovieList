import Foundation
import SwiftUI
import AVKit
import YouTubePlayerKit

enum TrailerSource: Identifiable, Equatable {
    case direct(URL)
    case youtube(id: String)

    var id: String {
        switch self {
        case let .direct(url):
            return "direct-\(url.absoluteString)"
        case let .youtube(id):
            return "youtube-\(id)"
        }
    }
}

struct TrailerPlayerView: View {
    let source: TrailerSource
    var onReady: (() -> Void)? = nil
    @State private var player: AVPlayer?
    @State private var isPresentingFullScreen = false

    var body: some View {
        switch source {
        case let .direct(url):
            directPlayer(url: url)
        case let .youtube(id):
            YouTubePlayerView(YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v=\(id)"))
                .onAppear { onReady?() }
        }
    }

    @ViewBuilder
    private func directPlayer(url: URL) -> some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: player)
                .background(Color.black.opacity(0.95))
                .onAppear {
                    if player == nil {
                        player = AVPlayer(url: url)
                    }
                    onReady?()
                }
                .onDisappear {
                    player?.pause()
                }
            Button {
                isPresentingFullScreen = true
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.caption.weight(.bold))
                    .padding(8)
                    .background(Color.black.opacity(0.4), in: Capsule())
                    .foregroundStyle(.white)
                    .padding(10)
            }
        }
        .sheet(isPresented: $isPresentingFullScreen, onDismiss: {
            player?.pause()
        }) {
            FullscreenPlayer(player: player ?? AVPlayer(url: url))
        }
    }
}

private struct FullscreenPlayer: View {
    let player: AVPlayer

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .background(Color.black)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}
