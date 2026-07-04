import SwiftUI

struct OngCardsListView: View {
    @State var ongs: [OngsWithDistance]

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]

        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(ongs, id: \.id) { ong in
                OngCardView(
                    image: ong.image,
                    title: ong.title,
                    distance: ong.distanceInKm
                )
            }
        }
        .padding(.bottom, 80)
        .padding(.top, 24)
    }
}
