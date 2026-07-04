import SwiftUI

struct CategoryChipSkeletonView: View {
    private let width: CGFloat

    init(width: CGFloat) {
        self.width = width
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.primaryLightGray)
            .frame(width: width, height: 48)
            .shimmering()
    }
}

#Preview {
    HStack(spacing: 8) {
        CategoryChipSkeletonView(width: 70)
        CategoryChipSkeletonView(width: 100)
        CategoryChipSkeletonView(width: 60)
    }
    .padding()
}
