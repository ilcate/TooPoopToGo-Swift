

import SwiftUI

struct SliderNextToYou: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager
    
    var body: some View {
        VStack(spacing: 6){
            HStack{
                Text("Next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .padding(.vertical, -1)
                Spacer()
                
            }.padding(.horizontal, 20)
            
            if !homeModel.nextToYou.isEmpty {
                VStack{
                    ScrollView(.horizontal){
                        HStack(spacing: 20){
                            ForEach(homeModel.nextToYou , id: \.self) { bathroom in
                                InformationOfSelectionView(bathroom: bathroom)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 20)
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                                //TODO: non riesco a mettere il fatto che si intraveda il successivo
                                
                            }
                        }
                        .padding(.trailing, 10)
                        .scrollTargetLayout()
                    }
                    .contentMargins(0, for: .scrollContent)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                }
                .padding(.vertical, -1)
                
            } else {
                Text("No bathroom next to you")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
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
