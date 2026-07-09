import SwiftUI

struct OngSceneErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.primaryBlack)

            Text("Ocorreu um erro")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primaryBlack)

            Text("Não conseguimos carregar os dados dessa ONG. Tente novamente.")
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
    OngSceneErrorView(onRetry: {})
}
