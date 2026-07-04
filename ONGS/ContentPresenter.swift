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
        viewState.state = .success(ongs: ongs)
    }

    func presentError() {
        viewState.state = .failure
    }

    func presentLoading() {
        viewState.state = .loading
    }
}
