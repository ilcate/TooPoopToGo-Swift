
import SwiftUI

struct AddAnnotationView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        VStack(spacing: 6) {
            Spacer()
            HStack {
                Spacer()
                Image("AddAnnotation")
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .foregroundStyle(Color.accent)
                    .onTapGesture {
                        mapViewModel.resetAndFollow(z: 18)
                        mapViewModel.canMoveCheck(duration: 0.5)
                    }
            }
            if mapViewModel.tappedAnnotation() {
                withAnimation(.snappy) {
                    InformationOfSelectionView(bathroom: mapViewModel.selected!, mapViewModel: mapViewModel)
                        .opacity(mapViewModel.selected?.name != "" ? 1 : 0)
                        .onChange(of: mapViewModel.viewport) { _, new in
                            if !mapViewModel.checkCoordinates() {
                                mapViewModel.removeSelection()
                            }
                        }
                        .padding(.top, 6)
                }
            }
        }
        .padding(.bottom, 72)
    }
}
