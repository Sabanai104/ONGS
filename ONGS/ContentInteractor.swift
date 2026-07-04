import Foundation
import CoreLocation

protocol ContentInteractorProtocol: AnyObject {
    func getOngs(title: String?, userLocation: CLLocation, category: String?) async
}

final class ContentInteractor: ContentInteractorProtocol {
    private let services: ContentServicing
    private let presenter: ContentPresenting

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

            var ongs = response.data

            if let title, title != "" {
                ongs = ongs.filter { ong in
                    ong.titulo.contains(title)
                }
            }

            let newResponse = ongs.map { ong in
                OngsWithDistance(
                    id: ong.id,
                    title: ong.titulo,
                    image: ong.imagem,
                    distanceInKm: ong.distance(from: userLocation)
                )
            }

            await presenter.presentOngs(ongs: newResponse)
        } catch {
            await presenter.presentError()
        }
    }
}
