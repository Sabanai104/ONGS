import SwiftUI

struct CachedAsyncImageView<Content>: View where Content: View {

    // MARK: - Private Properties

    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    // MARK: - Initialization

    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    // MARK: - Views

    var body: some View {
        if let url, let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    // MARK: - Private Functions

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if let url, case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

// MARK: - ImageCache

private enum ImageCache {

    private static var cache: [URL: Image] = [:]
    private static var maxCapacity = 100

    static subscript(url: URL) -> Image? {
        get {
            Self.cache[url]
        }
        set {
            clearIfNeeded()
            Self.cache[url] = newValue
        }
    }

    private static func clearIfNeeded() {
        if cache.count > maxCapacity {
            cache = [:]
        }
    }
}
