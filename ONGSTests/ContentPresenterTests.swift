import XCTest
@testable import ONGS

@MainActor
final class ContentPresenterTests: XCTestCase {

    func test_presentOngs_setsStateToSuccessWithGivenOngs() async {
        let viewState = ContentViewState()
        let sut = ContentPresenter(viewState: viewState)
        let ongs = [makeOng(id: "1"), makeOng(id: "2")]

        sut.presentOngs(ongs: ongs)

        assertSuccess(viewState.state, expectedIds: ["1", "2"])
    }

    func test_presentError_setsStateToFailure() async {
        let viewState = ContentViewState()
        let sut = ContentPresenter(viewState: viewState)
        sut.presentOngs(ongs: [makeOng(id: "1")])

        sut.presentError()

        assertFailure(viewState.state)
    }

    func test_presentLoading_setsStateToLoading() async {
        let viewState = ContentViewState()
        let sut = ContentPresenter(viewState: viewState)
        sut.presentOngs(ongs: [makeOng(id: "1")])

        sut.presentLoading()

        assertLoading(viewState.state)
    }

    func test_presentLoading_afterFailure_setsStateBackToLoading() async {
        let viewState = ContentViewState()
        let sut = ContentPresenter(viewState: viewState)
        sut.presentError()

        sut.presentLoading()

        assertLoading(viewState.state)
    }

    // MARK: - Helpers

    private func makeOng(id: String) -> OngsWithDistance {
        OngsWithDistance(id: id, title: "ONG \(id)", image: "https://example.com/\(id).png", distanceInKm: 1)
    }

    private func assertSuccess(_ state: OngsLoadState, expectedIds: [String], file: StaticString = #filePath, line: UInt = #line) {
        guard case .success(let ongs) = state else {
            XCTFail("Expected .success but got a different state", file: file, line: line)
            return
        }
        XCTAssertEqual(ongs.map(\.id), expectedIds, file: file, line: line)
    }

    private func assertFailure(_ state: OngsLoadState, file: StaticString = #filePath, line: UInt = #line) {
        guard case .failure = state else {
            XCTFail("Expected .failure but got a different state", file: file, line: line)
            return
        }
    }

    private func assertLoading(_ state: OngsLoadState, file: StaticString = #filePath, line: UInt = #line) {
        guard case .loading = state else {
            XCTFail("Expected .loading but got a different state", file: file, line: line)
            return
        }
    }
}
