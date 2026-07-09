import Foundation

final class CategoriesViewState: ObservableObject {
    @Published var state: CategoriesLoadState = .loading
}

enum CategoriesLoadState {
    case success(categories: [String])
    case loading
    case failure
}
