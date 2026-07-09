protocol OngSceneInteractorProtocol: AnyObject {
    func loadOng(id: String) async
}

final class OngSceneInteractor: OngSceneInteractorProtocol {
    private let service: OngSceneServicing
    private let presenter: OngScenePresenting

    init(service: OngSceneServicing, presenter: OngScenePresenting) {
        self.service = service
        self.presenter = presenter
    }

    func loadOng(id: String) async {
        await presenter.presentLoading()

        do {
            let ong = try await service.getOng(id: id)
            await presenter.presentOng(ong)
        } catch {
            await presenter.presentError()
        }
    }
}
