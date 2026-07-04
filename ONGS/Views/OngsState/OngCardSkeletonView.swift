import SwiftUI

struct OngCardSkeletonView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.primaryLightGray)
                .frame(height: 132)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 4)
                .shimmering()

            HStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.primaryLightGray)
                    .frame(width: 90, height: 10)
                    .shimmering()

                Spacer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(.primaryLightGray)
                    .frame(width: 40, height: 10)
                    .shimmering()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
        }
    }
}

#Preview {
    OngCardSkeletonView()
        .padding()
}
