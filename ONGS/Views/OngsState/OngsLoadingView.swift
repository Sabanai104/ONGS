import SwiftUI

struct OngsLoadingView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<6, id: \.self) { _ in
                OngCardSkeletonView()
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 80)
    }
}

#Preview {
    OngsLoadingView()
}
