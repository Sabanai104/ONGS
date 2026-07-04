import SwiftUI

protocol ContentPresenting {
    @MainActor func presentOngs(ongs: [OngsWithDistance])
    @MainActor func presentError()
    @MainActor func presentLoading()
}

@MainActor
final class ContentPresenter: ContentPresenting {
    let viewState: ContentViewState

    init(
        viewState: ContentViewState
    ) {
        self.viewState = viewState
    }

    func presentOngs(ongs: [OngsWithDistance]) {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .success(ongs: ongs)
        }
    }

    func presentError() {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .failure
        }
    }

    func presentLoading() {
        viewState.state = .loading
    }
}
