import SwiftUI

struct CategoryButtonView: View {
    @Binding private var choosedCategory: String?
    private let category: String?
    private let label: String

    init(
        choosedCategory: Binding<String?>,
        category: String?,
        label: String
    ) {
        self._choosedCategory = choosedCategory
        self.category = category
        self.label = label
    }
    
    var body: some View {
        Button {
            choosedCategory = category
        } label: {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primaryBlack)
        }
        .frame(minWidth: 55)
        .buttonStyle(.borderless)
        .padding(16)
        .background(
            choosedCategory == category ?
            RoundedRectangle(cornerRadius: 8)
                .fill(.secondaryColorGreen)
            :
            RoundedRectangle(cornerRadius: 8)
                .fill(.primaryLightGray)
        )
    }
}
