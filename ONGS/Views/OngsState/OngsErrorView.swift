import SwiftUI

struct OngsErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.secondaryColorGreen)

            Text("Ocorreu um erro")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primaryBlack)

            Text("Não conseguimos carregar as ongs. Verifique sua conexão e tente novamente.")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.label)
                .multilineTextAlignment(.center)

            Button(action: onRetry) {
                Text("Tentar novamente")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBlack)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.secondaryColorGreen)
                    )
            }
            .buttonStyle(.borderless)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 24)
        .padding(.top, 48)
    }
}

#Preview {
    OngsErrorView(onRetry: {})
}
