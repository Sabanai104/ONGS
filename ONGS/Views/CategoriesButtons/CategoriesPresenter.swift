import SwiftUI

protocol CategoriesPresenting {
    @MainActor func presentCategories(_ categories: [String])
    @MainActor func presentLoading()
    @MainActor func presentError()
}

@MainActor
final class CategoriesPresenter: CategoriesPresenting {
    let viewState: CategoriesViewState

    init(viewState: CategoriesViewState) {
        self.viewState = viewState
    }

    func presentCategories(_ categories: [String]) {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .success(categories: categories)
        }
    }

    func presentLoading() {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .loading
        }
    }

    func presentError() {
        withAnimation(.easeInOut(duration: 0.35)) {
            viewState.state = .failure
        }
    }
}
