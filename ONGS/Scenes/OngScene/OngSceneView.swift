import SwiftUI
import MapKit

struct OngSceneView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let id: String
    private let fallbackImage: String
    private let fallbackTitle: String
    private let interactor: OngSceneInteractorProtocol
    @StateObject private var viewState: OngSceneViewState

    init(
        id: String,
        fallbackImage: String,
        fallbackTitle: String,
        interactor: OngSceneInteractorProtocol,
        viewState: OngSceneViewState
    ) {
        self.id = id
        self.fallbackImage = fallbackImage
        self.fallbackTitle = fallbackTitle
        self.interactor = interactor
        _viewState = StateObject(wrappedValue: viewState)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView

                VStack(alignment: .leading) {
                    switch viewState.state {
                    case .loading:
                        info(title: fallbackTitle, subtitle: nil, address: nil, linkSite: nil, linkInstagram: nil)
                        OngSceneSkeletonView()

                    case .success(let ong):
                        info(
                            title: ong.titulo,
                            subtitle: ong.categorias.joined(separator: " · "),
                            address: ong.localizacao.nomeEndereco,
                            linkSite: ong.linkSite,
                            linkInstagram: ong.linkInstagram
                        )

                        OngSceneMapView(
                            latitude: ong.localizacao.latitude,
                            longitude: ong.localizacao.longitude,
                            markerTitle: ong.titulo
                        )
                        .padding(.horizontal, 16)

                        section(title: "Informações", content: ong.descricao)
                            .padding(.horizontal, 16)
                            .padding(.top, 24)

                        section(title: "Como você pode ajudar", content: ong.comoAjudar)
                            .padding(.horizontal, 16)
                            .padding(.top, 26)

                        section(title: "Impactos já realizados", content: ong.impactosRealizados)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)

                    case .failure:
                        OngSceneErrorView(onRetry: retry)
                    }
                }
                .offset(y: -20)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom) {
            donateButton
        }
        .background(.white)
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await interactor.loadOng(id: id)
        }
    }

    private func retry() {
        Task {
            await interactor.loadOng(id: id)
        }
    }

    private var currentImage: String {
        if case .success(let ong) = viewState.state {
            return ong.imagem
        }
        return fallbackImage
    }
}

extension OngSceneView {
    var headerView: some View {
        ZStack(alignment: .topLeading) {
            CachedAsyncImageView(
                url: URL(string: currentImage)
            ) { phase in
                switch phase {
                case .success(let img):
                    img.resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 258)
                default:
                    Color.pink.opacity(0.1)
                        .frame(height: 258)
                }
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .padding()
                    .background(Circle().fill(.thickMaterial))
            }
            .frame(alignment: .topLeading)
            .padding(.leading)
            .padding(.top, 44)
        }
        .frame(maxWidth: .infinity)
    }

    func info(
        title: String,
        subtitle: String?,
        address: String?,
        linkSite: String?,
        linkInstagram: String?
    ) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }

                if let address {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(address)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                }

                if linkSite != nil || linkInstagram != nil {
                    HStack(alignment: .top) {
                        if let linkSite, let url = URL(string: linkSite) {
                            iconButton("globe") { openURL(url) }
                        }

                        if let linkInstagram, let url = URL(string: linkInstagram) {
                            iconButton("camera") { openURL(url) }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .padding(.bottom, 8)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(40, corners: [.topLeft, .topRight])
    }

    func section(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(content)
                .font(.body)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func iconButton(_ systemName: String, action: @escaping () -> Void) -> some View {
        IconButtonView(systemName: systemName, action: action)
    }

    var donateButton: some View {
        Button {
            // ação de doar
        } label: {
            Text("Realizar uma doação")
                .font(.headline)
                .foregroundColor(.primaryBlack)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.secondaryColorGreen)
                )

        }
        .padding()
    }
}

private struct OngSceneMapView: View {
    let latitude: Double
    let longitude: Double
    let markerTitle: String

    @State private var cameraPosition: MapCameraPosition

    init(latitude: Double, longitude: Double, markerTitle: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.markerTitle = markerTitle
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }

    var body: some View {
        Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
            Marker(markerTitle, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        )
    }
}

extension View {
    func cornerRadius(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 40
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    OngSceneFactory.make(
        id: "665f1a2b3c4d5e6f7a8b9c0d",
        fallbackImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgpUeKf2KYp1BleqsUG-wX2qnCe5kRIh8uHA&s",
        fallbackTitle: "Grupo Mulheres do Brasil - Brasília"
    )
}
