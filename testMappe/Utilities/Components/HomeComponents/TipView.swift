import SwiftUI

struct TipView: View {
    @EnvironmentObject var api: ApiManager
    @State var tips: [Tip] = []
    @State var currentTipID: String? = nil

    var body: some View {
        if tips.isEmpty {
            Color.white
                .frame(width: 350, height: 155)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(tips) { tip in
                        VStack {
                            HStack {
                                HStack(spacing: 2) {
                                    Image("Advice")
                                        .renderingMode(.original)
                                    Text("Daily Advice")
                                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 12, fontColor: .accent)
                                }
                                .padding(.leading, 7)
                                .padding(.trailing, 6)
                                .padding(.vertical, 1)
                                .background(.ultraThickMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            
                            Spacer()
                            
                            VStack {
                                HStack {
                                    Text(tip.title)
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                                    Spacer()
                                }
                                .padding(.leading, 4)
                                HStack {
                                    Text(tip.description)
                                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 13, fontColor: .accent)
                                    Spacer()
                                }
                                .padding(.leading, 4)
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        .background(
                            CustomAsyncImage(
                                imageUrlString: tip.tip_photo,
                                placeholderImageName: "TipBG",
                                size: CGSize(width: 350, height: 145),
                                shape: .rectangle(cornerRadius: 16),
                                maxFrame: false
                            )
                            
                        )
                        .frame( width: 350, height: 145)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $currentTipID, anchor: .leading)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .ignoresSafeArea(.all, edges: .top)
        }
        
        HStack(spacing: 6) {
            ForEach(tips, id: \.self) { position in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(position.id == currentTipID ? .accent : .cLightBrown50)
            }
        }
        .padding(.bottom, -8)
        .padding(.top, 2)
        .onAppear {
            api.getTip { res in
                switch res {
                case .success(let suggest):
                    tips = suggest.results!
                    if let firstTip = tips.first {
                        currentTipID = firstTip.id
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
