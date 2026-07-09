import SwiftUI

protocol OngScenePresenting {
    @MainActor func presentOng(_ ong: OngDetailResponse)
    @MainActor func presentError()
    @MainActor func presentLoading()
}

@MainActor
final class OngScenePresenter: OngScenePresenting {
    let viewState: OngSceneViewState

    init(viewState: OngSceneViewState) {
        self.viewState = viewState
    }

    func presentOng(_ ong: OngDetailResponse) {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .success(ong: ong)
        }
    }

    func presentError() {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .failure
        }
    }

    func presentLoading() {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .loading
        }
    }
}
