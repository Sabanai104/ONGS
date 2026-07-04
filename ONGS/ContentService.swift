import Foundation
import CoreLocation

protocol ContentServicing: AnyObject {
    func getOngs(
        categoria: String?,
        lat: Double?,
        lng: Double?,
        raioKm: Double?,
        page: Int,
        limit: Int
    ) async throws -> OngsListResponse
}

enum ContentServiceError: Error {
    case invalidURL
    case invalidResponse
}

final class ContentService: ContentServicing {
    private let baseURL: URL?
    private let urlSession: URLSession
    private let localDataSource: OngsLocalDataSource

    init(
        baseURL: URL? = URL(string: "http://localhost:3000"),
        urlSession: URLSession = .shared,
        localDataSource: OngsLocalDataSource = BundledOngsDataSource()
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.localDataSource = localDataSource
    }

    func getOngs(
        categoria: String?,
        lat: Double?,
        lng: Double?,
        raioKm: Double?,
        page: Int,
        limit: Int
    ) async throws -> OngsListResponse {
        guard let baseURL else {
            return try localDataSource.loadOngs()
        }

        do {
            let response = try await fetchOngs(
                baseURL: baseURL,
                categoria: categoria,
                lat: lat,
                lng: lng,
                raioKm: raioKm,
                page: page,
                limit: limit
            )

            return response.data.isEmpty ? try localDataSource.loadOngs() : response
        } catch {
            return try localDataSource.loadOngs()
        }
    }

    private func fetchOngs(
        baseURL: URL,
        categoria: String?,
        lat: Double?,
        lng: Double?,
        raioKm: Double?,
        page: Int,
        limit: Int
    ) async throws -> OngsListResponse {
        let url = try makeOngsURL(
            baseURL: baseURL,
            categoria: categoria,
            lat: lat,
            lng: lng,
            raioKm: raioKm,
            page: page,
            limit: limit
        )

        let (data, response) = try await urlSession.data(from: url)
        try validate(response)

        return try JSONDecoder().decode(OngsListResponse.self, from: data)
    }

    private func makeOngsURL(
        baseURL: URL,
        categoria: String?,
        lat: Double?,
        lng: Double?,
        raioKm: Double?,
        page: Int,
        limit: Int
    ) throws -> URL {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent("ongs"),
            resolvingAgainstBaseURL: false
        ) else {
            throw ContentServiceError.invalidURL
        }

        components.queryItems = makeQueryItems(
            categoria: categoria,
            lat: lat,
            lng: lng,
            raioKm: raioKm,
            page: page,
            limit: limit
        )

        guard let url = components.url else {
            throw ContentServiceError.invalidURL
        }

        return url
    }

    private func makeQueryItems(
        categoria: String?,
        lat: Double?,
        lng: Double?,
        raioKm: Double?,
        page: Int,
        limit: Int
    ) -> [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]

        if let categoria, !categoria.isEmpty {
            queryItems.append(URLQueryItem(name: "categoria", value: categoria))
        }

        if let lat, let lng {
            queryItems.append(URLQueryItem(name: "lat", value: String(lat)))
            queryItems.append(URLQueryItem(name: "lng", value: String(lng)))

            if let raioKm {
                queryItems.append(URLQueryItem(name: "raioKm", value: String(raioKm)))
            }
        }

        return queryItems
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw ContentServiceError.invalidResponse
        }
    }
}

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()

    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestPermission() {
        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }

    func requestLocationIfPossible() {
        if authorizationStatus == .authorizedWhenInUse ||
           authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            print("❌ Permissão de localização negada")

        case .notDetermined:
            break

        @unknown default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        userLocation = locations.first
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("❌ Erro ao obter localização:", error)
    }
}

