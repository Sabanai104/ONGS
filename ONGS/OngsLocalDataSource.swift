import Foundation

protocol OngsLocalDataSource {
    func loadOngs() throws -> OngsListResponse
}

enum OngsLocalDataSourceError: Error {
    case fileNotFound
}

final class BundledOngsDataSource: OngsLocalDataSource {
    private let bundle: Bundle
    private let fileName: String

    init(bundle: Bundle = .main, fileName: String = "OngsSimplifiedList") {
        self.bundle = bundle
        self.fileName = fileName
    }

    func loadOngs() throws -> OngsListResponse {
        guard let url = bundle.url(forResource: fileName, withExtension: "JSON") else {
            throw OngsLocalDataSourceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(OngsSimplifiedResponse.self, from: data)

        return response.asOngsListResponse
    }
}
