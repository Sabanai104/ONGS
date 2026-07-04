enum ContentFactory {
    @MainActor static func make() -> ContentView {
        let viewState = ContentViewState()
        let service = ContentService()
        let presenter = ContentPresenter(viewState: viewState)
        let interactor = ContentInteractor(services: service, presenter: presenter)

        return ContentView(interactor: interactor, viewState: viewState)
    }
}
