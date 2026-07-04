import Foundation

final class ContentViewState: ObservableObject {
    @Published var state: OngsLoadState = .loading
}

enum OngsLoadState {
    case success(ongs: [OngsWithDistance])
    case failure
    case loading
}
