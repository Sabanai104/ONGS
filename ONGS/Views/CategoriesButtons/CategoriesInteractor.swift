protocol CategoriesInteractorProtocol: AnyObject {
    func loadCategories() async
}

final class CategoriesInteractor: CategoriesInteractorProtocol {
    private let service: CategoriesServicing
    private let presenter: CategoriesPresenting

    init(service: CategoriesServicing, presenter: CategoriesPresenting) {
        self.service = service
        self.presenter = presenter
    }

    func loadCategories() async {
        await presenter.presentLoading()

        let categories = await service.getCategories()

        await presenter.presentCategories(categories)
    }
}
