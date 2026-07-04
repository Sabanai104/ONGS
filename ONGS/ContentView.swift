import SwiftUI

struct ContentView: View {
    @State var searchInput: String = ""
    @State var choosedCategory: String?

    private let interactor: ContentInteractorProtocol
    @StateObject private var viewState: ContentViewState
    @StateObject private var locationManager = LocationManager()

    init(
        interactor: ContentInteractorProtocol,
        viewState: ContentViewState
    ) {
        self.interactor = interactor
        _viewState = StateObject(wrappedValue: viewState)
    }

    var body: some View {
        NavigationStack {
            ScrollView() {
                VStack(alignment: .leading, spacing: .zero) {
                    CategoriesButtonsView(choosedCategory: $choosedCategory)
                    Text("Todas as categorias")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.primaryBlack)
                        .padding(.top, 24)
                    
                    Text("Encontre a ong que faz mais sentido com seu proposito e ajude já!")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.label)
                        .padding(.top, 8)
                    
                    switch viewState.state {
                    case .success(let ongs):
                        OngCardsListView(ongs: ongs)
                    case .loading:
                        OngsLoadingView()
                    case .failure:
                        OngsErrorView(onRetry: loadOngs)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .searchable(text: $searchInput)
                .ignoresSafeArea(.all, edges: .bottom)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.thinMaterial, for: .navigationBar)
        .padding(0)
        .onChange(of: searchInput) { oldValue, newValue in
            loadOngs()
        }
        .onChange(of: choosedCategory) { oldValue, newValue in
            loadOngs()
        }
        .task {
            locationManager.requestPermission()
        }
        .onChange(of: locationManager.userLocation) { oldValue, newValue in
            loadOngs()
        }
    }

    private func loadOngs() {
        guard let location = locationManager.userLocation else { return }

        Task {
            await interactor.getOngs(
                title: searchInput,
                userLocation: location,
                category: choosedCategory
            )
        }
    }
}

//#Preview {
//    ContentView()
//}

