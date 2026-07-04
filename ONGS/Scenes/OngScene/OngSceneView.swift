import SwiftUI
import MapKit

struct OngSceneView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: -15.8021622,
                longitude: -47.934954217
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
    )

    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    headerView

                    VStack(alignment: .leading) {
                        info

                        mapView
                            .padding(.horizontal, 16)


                        section(
                            title: "Informações",
                            content: "Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus dui convallis."
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 24)


                        bulletSection(
                            title: "Como você pode ajudar",
                            items: [
                                "Profissionais qualificadas que possam ensinar sobre violência contra mulher;",
                                "Profissionais qualificadas que possam ensinar aulas de defesa pessoal para mulheres;",
                                "Doações para compra de materiais."
                            ]
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 26)


                        bulletSection(
                            title: "Impactos já realizados",
                            items: [
                                "80% de Lorem ipsum",
                                "57% de Lorem ipsum",
                                "Redução de 32% de Lorem ipsum"
                            ]
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

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
    }
}

extension OngSceneView {
    var headerView: some View {
        ZStack(alignment: .topLeading) {
            CachedAsyncImageView(
                url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgpUeKf2KYp1BleqsUG-wX2qnCe5kRIh8uHA&s")
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

    var info: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Grupo Mulheres do Brasil - Brasília")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("Feminino · Doações · Empreendedorismo")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 4)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Setor comercial sul · Brasília · 16km")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 4)

                HStack(alignment: .top) {
                    iconButton("globe")
                    iconButton("camera")
                    iconButton("message")
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .padding(.bottom, 8)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(40, corners: [.topLeft, .topRight])
    }

    var mapView: some View {
        Map(position: $cameraPosition, interactionModes: [.pan, .zoom]) {
            Marker(
                "Grupo Mulheres do Brasil",
                coordinate: CLLocationCoordinate2D(
                    latitude: -15.8021622,
                    longitude: -47.934954217
                )
            )
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        )
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

        func bulletSection(title: String, items: [String]) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)

                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top) {
                        Text("•")
                        Text(item)
                    }
                    .font(.body)
                    .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

    func iconButton(_ systemName: String) -> some View {
        IconButtonView(systemName: systemName)
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
    OngSceneView()
}
