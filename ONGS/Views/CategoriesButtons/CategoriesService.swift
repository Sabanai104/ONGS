import Foundation

protocol CategoriesServicing: AnyObject {
    func getCategories() async throws -> [Categoria]
}

enum CategoriesServiceError: Error {
    case invalidURL
    case invalidResponse
}

final class CategoriesService: CategoriesServicing {
    private let baseURL: URL?
    private let urlSession: URLSession

    init(
        baseURL: URL? = URL(string: "http://localhost:3000"),
        urlSession: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    func getCategories() async throws -> [Categoria] {
        guard let baseURL else {
            throw CategoriesServiceError.invalidURL
        }

        let url = baseURL.appendingPathComponent("categorias")

        let (data, response) = try await urlSession.data(from: url)
        try validate(response)

        return try JSONDecoder().decode([Categoria].self, from: data)
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw CategoriesServiceError.invalidResponse
        }
    }
}
