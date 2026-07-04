import Foundation
import CoreLocation

protocol ContentInteractorProtocol: AnyObject {
    func getOngs(title: String?, userLocation: CLLocation, category: String?) async
    func filterOngs(title: String?) async
}

final class ContentInteractor: ContentInteractorProtocol {
    private let services: ContentServicing
    private let presenter: ContentPresenting
    private var lastLoadedOngs: [OngsWithDistance] = []

    init(services: ContentServicing, presenter: ContentPresenting) {
        self.services = services
        self.presenter = presenter
    }

    func getOngs(title: String? = nil, userLocation: CLLocation, category: String? = nil) async {
        await presenter.presentLoading()

        do {
            let response = try await services.getOngs(
                categoria: category,
                lat: nil,
                lng: nil,
                raioKm: nil,
                page: 1,
                limit: 50
            )

            lastLoadedOngs = response.data.map { ong in
                OngsWithDistance(
                    id: ong.id,
                    title: ong.titulo,
                    image: ong.imagem,
                    distanceInKm: ong.distance(from: userLocation)
                )
            }

            await presenter.presentOngs(ongs: filtered(byTitle: title))
        } catch {
            await presenter.presentError()
        }
    }

    func filterOngs(title: String?) async {
        await presenter.presentOngs(ongs: filtered(byTitle: title))
    }

    private func filtered(byTitle title: String?) -> [OngsWithDistance] {
        guard let title, !title.isEmpty else { return lastLoadedOngs }

        return lastLoadedOngs.filter { $0.title.localizedCaseInsensitiveContains(title) }
    }
}
