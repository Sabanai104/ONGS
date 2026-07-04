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
        .buttonStyle(PressableButtonStyle())
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(choosedCategory == category ? .secondaryColorGreen : .primaryLightGray)
        )
        .animation(.easeInOut(duration: 0.2), value: choosedCategory)
    }
}

private struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
