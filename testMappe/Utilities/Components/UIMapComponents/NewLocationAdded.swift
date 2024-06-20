
import SwiftUI


struct NewLocationAddedView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Thank you for your submission!")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 26, fontColor: .accent)
                        .frame(maxHeight: 80)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, -8)
                    Text("Our moderators will review it shortly. If all goes well, the bathroom will be online within a couple of days.")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                        .padding(.bottom, 4)
                    FullRoundedButton(text: "Gotcha!")
                        .padding(.horizontal, -20)
                        .onTapGesture {
                            mapViewModel.newLocationAdded = false
                        }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .padding(.top, 6)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 36)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
    }
}
