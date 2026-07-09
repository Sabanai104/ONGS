import XCTest
import CoreLocation
@testable import ONGS

final class ContentInteractorTests: XCTestCase {

    // MARK: - presentLoading

    func test_getOngs_callsPresentLoadingBeforeFetching() async {
        let serviceMock = ServiceMock()
        serviceMock.resultToReturn = .success(makeResponse(ids: ["1"]))
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.getOngs(title: nil, userLocation: makeLocation(), category: nil)

        let loadingCallCount = await presenterMock.loadingCallCount
        XCTAssertEqual(loadingCallCount, 1)
    }

    // MARK: - success mapping

    func test_getOngs_onSuccess_mapsResponseToOngsWithDistance() async {
        let serviceMock = ServiceMock()
        let ongLocation = CLLocation(latitude: -15.8021622, longitude: -47.934954217)
        serviceMock.resultToReturn = .success(
            makeResponse(ids: ["1"], latitude: ongLocation.coordinate.latitude, longitude: ongLocation.coordinate.longitude)
        )
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        let userLocation = CLLocation(latitude: -15.7893371, longitude: -47.9673263)
        await sut.getOngs(title: nil, userLocation: userLocation, category: nil)

        let presentedOngs = await presenterMock.presentedOngs
        let ongs = presentedOngs.last
        XCTAssertEqual(ongs?.count, 1)
        XCTAssertEqual(ongs?.first?.id, "1")
        XCTAssertEqual(ongs?.first?.title, "ONG 1")
        XCTAssertEqual(ongs?.first?.image, "https://example.com/1.png")

        let expectedDistanceInKm = userLocation.distance(from: ongLocation) / 1000
        XCTAssertEqual(ongs?.first?.distanceInKm ?? -1, expectedDistanceInKm, accuracy: 0.01)
    }

    // MARK: - categoria passthrough

    func test_getOngs_passesCategoryToService() async {
        let serviceMock = ServiceMock()
        serviceMock.resultToReturn = .success(makeResponse(ids: ["1"]))
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.getOngs(title: nil, userLocation: makeLocation(), category: "Apoio aos animais")

        XCTAssertEqual(serviceMock.receivedCategorias, ["Apoio aos animais"])
    }

    // MARK: - title filtering

    func test_getOngs_withTitle_filtersCaseInsensitively() async {
        let serviceMock = ServiceMock()
        serviceMock.resultToReturn = .success(makeResponse(ids: ["1", "2"], titles: ["Amigos da Vida", "Cáritas"]))
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.getOngs(title: "amigos", userLocation: makeLocation(), category: nil)

        let presentedOngs = await presenterMock.presentedOngs
        XCTAssertEqual(presentedOngs.last?.map(\.title), ["Amigos da Vida"])
    }

    // MARK: - error handling

    func test_getOngs_whenServiceThrows_callsPresentErrorAndNotPresentOngs() async {
        let serviceMock = ServiceMock()
        serviceMock.resultToReturn = .failure(URLError(.notConnectedToInternet))
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.getOngs(title: nil, userLocation: makeLocation(), category: nil)

        let errorCallCount = await presenterMock.errorCallCount
        let presentedOngs = await presenterMock.presentedOngs
        XCTAssertEqual(errorCallCount, 1)
        XCTAssertTrue(presentedOngs.isEmpty)
    }

    // MARK: - filterOngs

    func test_filterOngs_withoutPriorFetch_presentsEmptyList() async {
        let serviceMock = ServiceMock()
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.filterOngs(title: "qualquer coisa")

        let presentedOngs = await presenterMock.presentedOngs
        XCTAssertEqual(presentedOngs.last?.isEmpty, true)
    }

    func test_filterOngs_afterSuccessfulFetch_filtersInMemoryWithoutCallingServiceAgain() async {
        let serviceMock = ServiceMock()
        serviceMock.resultToReturn = .success(makeResponse(ids: ["1", "2"], titles: ["Amigos da Vida", "Cáritas"]))
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.getOngs(title: nil, userLocation: makeLocation(), category: nil)
        await sut.filterOngs(title: "cáritas")

        XCTAssertEqual(serviceMock.callCount, 1)
        let presentedOngs = await presenterMock.presentedOngs
        XCTAssertEqual(presentedOngs.last?.map(\.title), ["Cáritas"])
    }

    func test_filterOngs_withNilOrEmptyTitle_returnsFullList() async {
        let serviceMock = ServiceMock()
        serviceMock.resultToReturn = .success(makeResponse(ids: ["1", "2"], titles: ["Amigos da Vida", "Cáritas"]))
        let presenterMock = await PresenterMock()
        let sut = ContentInteractor(services: serviceMock, presenter: presenterMock)

        await sut.getOngs(title: nil, userLocation: makeLocation(), category: nil)
        await sut.filterOngs(title: "")

        let presentedOngs = await presenterMock.presentedOngs
        XCTAssertEqual(presentedOngs.last?.map(\.id), ["1", "2"])
    }

    // MARK: - Helpers

    private func makeLocation() -> CLLocation {
        CLLocation(latitude: -15.7893371, longitude: -47.9673263)
    }

    private func makeResponse(
        ids: [String],
        titles: [String]? = nil,
        latitude: Double = 0,
        longitude: Double = 0
    ) -> OngsListResponse {
        let data = ids.enumerated().map { index, id in
            OngSummary(
                id: id,
                titulo: titles?[index] ?? "ONG \(id)",
                imagem: "https://example.com/\(id).png",
                localizacao: OngLocationSummary(latitude: latitude, longitude: longitude)
            )
        }
        return OngsListResponse(
            data: data,
            pagination: OngsPagination(page: 1, limit: ids.count, total: ids.count, totalPages: 1)
        )
    }
}

// MARK: - Test doubles

private final class ServiceMock: ContentServicing {
    var resultToReturn: Result<OngsListResponse, Error> = .success(
        OngsListResponse(data: [], pagination: OngsPagination(page: 0, limit: 0, total: 0, totalPages: 0))
    )
    private(set) var callCount = 0
    private(set) var receivedCategorias: [String?] = []

    func getOngs(
        categoria: String?,
        lat: Double?,
        lng: Double?,
        raioKm: Double?,
        page: Int,
        limit: Int
    ) async throws -> OngsListResponse {
        callCount += 1
        receivedCategorias.append(categoria)
        return try resultToReturn.get()
    }
}

@MainActor
private final class PresenterMock: ContentPresenting {
    private(set) var loadingCallCount = 0
    private(set) var errorCallCount = 0
    private(set) var presentedOngs: [[OngsWithDistance]] = []

    func presentOngs(ongs: [OngsWithDistance]) {
        presentedOngs.append(ongs)
    }

    func presentError() {
        errorCallCount += 1
    }

    func presentLoading() {
        loadingCallCount += 1
    }
}
