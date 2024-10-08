import SwiftUI

struct SliderNextToYou: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var mapViewModel: MapModel
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .padding(.vertical, -1)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if !homeModel.nextToYou.isEmpty {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(homeModel.nextToYou.reversed(), id: \.self) { bathroom in
                                InformationOfSelectionView(bathroom: bathroom, mapViewModel: mapViewModel)
                                    .padding(.vertical, 3)
                                    .frame(width: 350)
                                
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .scrollTargetLayout()
                    }
                    .contentMargins(0, for: .scrollContent)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .padding(.vertical, -1)
            } else {
                Text("No bathroom next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 114)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
            }
        }
        .task {
            homeModel.foundNextToYou(api: api)
        }
    }
}
