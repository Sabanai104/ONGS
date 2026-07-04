import Foundation

protocol CategoriesServicing: AnyObject {
    func getCategories() async -> [String]
}

final class CategoriesService: CategoriesServicing {
    private let categories: [String]
    private let simulatedDelayNanoseconds: UInt64

    init(
        categories: [String] = defaultCategories,
        simulatedDelayNanoseconds: UInt64 = 600_000_000
    ) {
        self.categories = categories
        self.simulatedDelayNanoseconds = simulatedDelayNanoseconds
    }

    func getCategories() async -> [String] {
        try? await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return categories
    }

    static let defaultCategories = [
        "Apoio a mulheres",
        "Apoio aos animais",
        "Apoio aos necessitados",
        "Moradores de rua",
        "PCDs",
        "Apoio a causas LGBT",
        "Naruto",
        "Causas raciais",
        "Sei la mais"
    ]
}
