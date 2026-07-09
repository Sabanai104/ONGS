import Foundation

protocol OngSceneServicing: AnyObject {
    func getOng(id: String) async throws -> OngDetailResponse
}

enum OngSceneServiceError: Error {
    case invalidURL
    case invalidResponse
}

final class OngSceneService: OngSceneServicing {
    private let baseURL: URL?
    private let urlSession: URLSession

    init(
        baseURL: URL? = URL(string: "http://localhost:3000"),
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    func getOng(id: String) async throws -> OngDetailResponse {
        guard let baseURL else {
            throw OngSceneServiceError.invalidURL
        }

        let url = baseURL.appendingPathComponent("ongs").appendingPathComponent(id)

        let (data, response) = try await urlSession.data(from: url)
        try validate(response)

        return try JSONDecoder().decode(OngDetailResponse.self, from: data)
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw OngSceneServiceError.invalidResponse
        }
    }
}
