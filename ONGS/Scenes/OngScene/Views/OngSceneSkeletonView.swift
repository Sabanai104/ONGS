import SwiftUI

struct OngSceneSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.primaryLightGray)
                .frame(width: 160, height: 12)
                .shimmering()

            RoundedRectangle(cornerRadius: 16)
                .fill(.primaryLightGray)
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .shimmering()
                .padding(.top, 8)

            Group {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.primaryLightGray)
                    .frame(width: 100, height: 14)
                    .shimmering()
                    .padding(.top, 24)

                RoundedRectangle(cornerRadius: 4)
                    .fill(.primaryLightGray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .shimmering()
                    .padding(.top, 8)
            }

            Group {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.primaryLightGray)
                    .frame(width: 180, height: 14)
                    .shimmering()
                    .padding(.top, 26)

                RoundedRectangle(cornerRadius: 4)
                    .fill(.primaryLightGray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .shimmering()
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

#Preview {
    OngSceneSkeletonView()
}
