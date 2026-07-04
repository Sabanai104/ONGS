import SwiftUI

struct OngCardsListView: View {
    let ongs: [OngsWithDistance]

    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]

        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(ongs, id: \.id) { ong in
                OngCardView(
                    id: ong.id,
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
