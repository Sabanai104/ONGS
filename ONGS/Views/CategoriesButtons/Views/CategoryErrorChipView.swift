import SwiftUI

struct CategoryErrorChipView: View {
    let onRetry: () -> Void

    var body: some View {
        Button(action: onRetry) {
            HStack(spacing: 8) {
                Text("Erro ao carregar")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primaryBlack)

                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBlack)
            }
            .padding(.horizontal, 16)
        }
        .buttonStyle(.borderless)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.primaryLightGray)
        )
    }
}

#Preview {
    CategoryErrorChipView(onRetry: {})
        .padding()
}
