import SwiftUI

struct OngCardView: View {
    @Namespace private var heroAnimation

    private let id: String
    private let image: String
    private let title: String
    private let distance: Double

    init(id: String, image: String, title: String, distance: Double) {
        self.id = id
        self.image = image
        self.title = title
        self.distance = distance
    }

    var body: some View {
        NavigationLink(
            destination: OngSceneFactory.make(id: id, fallbackImage: image, fallbackTitle: title)
                .navigationTransition(.zoom(sourceID: id, in: heroAnimation))
        ) {
            VStack {
                CachedAsyncImageView(url: URL(string: image), scale: 2, transaction: .init(animation: .easeIn)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 132)
                            .padding(.bottom, 4)
                            .cornerRadius(16, corners: .allCorners)
                    case .failure:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray)
                            .frame(height: 132)
                            .frame(maxWidth: .infinity)
                    default:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray)
                            .frame(height: 132)
                            .frame(maxWidth: .infinity)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.primaryLightGray, lineWidth: 3)
                )

                HStack(alignment: .center) {
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.label)
                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: "mappin")
                            .foregroundColor(.red)

                        Text(String(format: "%.1f km", distance))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.label)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
            }
        }
        .matchedTransitionSource(id: id, in: heroAnimation)
        .transition(.opacity.combined(with: .scale(scale: 0.94)))
    }
}
