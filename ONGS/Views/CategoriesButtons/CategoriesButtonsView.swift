import SwiftUI

struct CategoriesButtonsView: View {
    @Binding private var choosedCategory: String?

    private let interactor: CategoriesInteractorProtocol
    @StateObject private var viewState: CategoriesViewState

    init(
        interactor: CategoriesInteractorProtocol,
        viewState: CategoriesViewState,
        choosedCategory: Binding<String?>
    ) {
        self.interactor = interactor
        _viewState = StateObject(wrappedValue: viewState)
        self._choosedCategory = choosedCategory
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                switch viewState.state {
                case .loading:
                    CategoryChipSkeletonView(width: 70)
                    CategoryChipSkeletonView(width: 140)
                    CategoryChipSkeletonView(width: 110)
                    CategoryChipSkeletonView(width: 90)
                    CategoryChipSkeletonView(width: 130)
                case .success(let categories):
                    CategoryButtonView(choosedCategory: $choosedCategory, category: nil, label: "Todos")
                        .transition(.opacity)
                    ForEach(categories, id: \.self) { category in
                        CategoryButtonView(choosedCategory: $choosedCategory, category: category, label: category)
                            .transition(.opacity)
                    }
                case .failure:
                    CategoryErrorChipView {
                        Task { await interactor.loadCategories() }
                    }
                    .transition(.opacity)
                }
            }
        }
        .task {
            await interactor.loadCategories()
        }
    }
}
