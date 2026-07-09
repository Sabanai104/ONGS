import Foundation

final class OngSceneViewState: ObservableObject {
    @Published var state: OngDetailLoadState = .loading
}

enum OngDetailLoadState {
    case success(ong: OngDetailResponse)
    case failure
    case loading
}
