import SwiftUI

enum CategoriesFactory {
    @MainActor static func make(choosedCategory: Binding<String?>) -> CategoriesButtonsView {
        let viewState = CategoriesViewState()
        let service = CategoriesService()
        let presenter = CategoriesPresenter(viewState: viewState)
        let interactor = CategoriesInteractor(service: service, presenter: presenter)

        return CategoriesButtonsView(
            interactor: interactor,
            viewState: viewState,
            choosedCategory: choosedCategory
        )
    }
}
