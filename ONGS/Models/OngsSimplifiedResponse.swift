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

struct OngsSimplifiedResponse: Decodable {
    let status: String
    let data: [OngSimplified]
}

struct OngSimplified: Decodable {
    let id: String
    let title: String
    let image: String
    let localization: OngSimplifiedLocation
    let category: Int
}

struct OngSimplifiedLocation: Decodable {
    let lat: Double
    let lng: Double
}

extension OngsSimplifiedResponse {
    var asOngsListResponse: OngsListResponse {
        OngsListResponse(
            data: data.map(\.asOngSummary),
            pagination: OngsPagination(page: 1, limit: data.count, total: data.count, totalPages: 1)
        )
    }
}

private extension OngSimplified {
    var asOngSummary: OngSummary {
        OngSummary(
            id: id,
            titulo: title,
            imagem: image,
            localizacao: OngLocationSummary(latitude: localization.lat, longitude: localization.lng)
        )
    }
}
