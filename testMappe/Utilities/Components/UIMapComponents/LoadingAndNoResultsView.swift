
import SwiftUI
import Lottie

struct LoadingAndNoResultsView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        HStack {
            if mapViewModel.isLoading {
                LottieView(animation: .named("DotAnim.json"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                    })
                    .frame(width: 50, height: 34)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
            }

            if mapViewModel.allPoints.isEmpty && !mapViewModel.isLoading {
                Text("No results in this area")
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 14, fontColor: .accent)
                    .frame(width: 185, height: 32)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
            }
        }
        .padding(.top, 8)
    }
}
