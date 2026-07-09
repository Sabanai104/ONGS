enum OngSceneFactory {
    @MainActor static func make(id: String, fallbackImage: String, fallbackTitle: String) -> OngSceneView {
        let viewState = OngSceneViewState()
        let service = OngSceneService()
        let presenter = OngScenePresenter(viewState: viewState)
        let interactor = OngSceneInteractor(service: service, presenter: presenter)

        return OngSceneView(
            id: id,
            fallbackImage: fallbackImage,
            fallbackTitle: fallbackTitle,
            interactor: interactor,
            viewState: viewState
        )
    }
}
