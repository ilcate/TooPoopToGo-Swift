
import SwiftUI

struct ResetPositionButton: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        Image("ResetPosition")
            .uiButtonStyle(backgroundColor: .white)
            .onTapGesture {
                mapViewModel.resetAndFollow(z: 15)
            }
    }
}
