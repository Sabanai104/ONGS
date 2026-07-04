import SwiftUI

struct IconButtonView: View {
    @State var animate = false
    private let systemName: String
    
    init(systemName: String) {
        self.systemName = systemName
    }

    var body: some View {
        Button {
            animate.toggle()
        } label: {
            ZStack {
                Color.primaryLightGray
                    .frame(width: 48, height: 48)
                    .cornerRadius(1000, corners: .allCorners)
                Image(systemName: systemName)
                    .renderingMode(.template)
                    .scaleEffect(1.2)
                    .foregroundStyle(.label)
                    .symbolEffect(.breathe, value: animate)
            }
        }
    }
}

