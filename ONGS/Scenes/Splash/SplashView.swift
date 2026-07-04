import SwiftUI

struct SplashView<Content: View>: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0

    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            if isActive {
                content()
                    .transition(.opacity.combined(with: .scale(scale: 1.03)))
            } else {
                splash
                    .transition(.opacity)
            }
        }
        .onAppear(perform: animateIn)
    }

    private var splash: some View {
        ZStack {
            Color.primaryBlack.ignoresSafeArea()

            VStack(spacing: 8) {
                Text("ONGS")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.secondaryColorGreen)

                Text("Conectando você a quem precisa")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
        }
    }

    private func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            logoScale = 1
            logoOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashView {
        Text("Conteúdo do app")
    }
}
