import SwiftUI


struct CustomDividerView: View {
    var body: some View {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightGray)
    }
}

