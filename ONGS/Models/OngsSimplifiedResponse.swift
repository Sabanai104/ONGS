import CoreLocation

struct OngsListResponse: Decodable {
    let data: [OngSummary]
    let pagination: OngsPagination
}

struct OngSummary: Decodable, Identifiable {
    let id: String
    let titulo: String
    let imagem: String
    let localizacao: OngLocationSummary
}

struct OngLocationSummary: Decodable {
    let latitude: Double
    let longitude: Double
}

struct OngsPagination: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
}

extension OngSummary {
    func distance(from userLocation: CLLocation) -> Double {
        let ongLocation = CLLocation(
            latitude: localizacao.latitude,
            longitude: localizacao.longitude
        )

        let distanceInMeters = userLocation.distance(from: ongLocation)
        return distanceInMeters / 1000
    }
}


struct OngsWithDistance: Identifiable {
    let id: String
    let title: String
    let image: String
    let distanceInKm: Double
}
