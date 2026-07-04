import SwiftUI

struct CategoriesButtonsView: View {
    @Binding private var choosedCategory: String?

    init(choosedCategory: Binding<String?>) {
        self._choosedCategory = choosedCategory
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryButtonView(choosedCategory: $choosedCategory, category: nil, label: "Todos")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Apoio a mulheres", label: "Apoio a mulheres")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Apoio aos animais", label: "Apoio aos animais")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Apoio aos necessitados", label: "Apoio aos necessitados")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Moradores de rua", label: "Moradores de rua")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "PCDs", label: "PCDs")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Apoio a causas LGBT", label: "Apoio a causas LGBT")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Naruto", label: "Naruto")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Causas raciais", label: "Causas raciais")
                CategoryButtonView(choosedCategory: $choosedCategory, category: "Sei la mais", label: "Sei la mais")
            }
        }
    }
}
