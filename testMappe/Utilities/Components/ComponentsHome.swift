

import SwiftUI

struct SliderNextToYou: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager

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
                                InformationOfSelectionView(bathroom: bathroom)
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

struct StreakButtons: View {
    @State var streak : Int

    var body: some View {
        VStack(spacing:6){
            HStack{
                Text("Streak")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
            }
            if streak != 0 {
                
                ZStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("Poop Streak!")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 30, fontColor: .cLightBrown)
                            Spacer()
                        }
                        Spacer()
                    }.padding(.top, 12)
                    VStack{
                        Spacer()
                        HStack(alignment: .bottom){
                            VStack(alignment: .leading){
                                Text("Keep it going!")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                                
                                ButtonPoop(text: "Drop a Poop")
                                    .onTapGesture {
                                        streak += 1
                                    }
                            }

                            Spacer()
                        }
                        
                    }.padding(.bottom, 16)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Text("\(streak)")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 100, fontColor: .cLightBrown)
                        }
                        
                    }
                    .padding(.bottom, -12)
                    
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: 140)
                .background(
                    Image("ImagePlaceHolder8")
                        .resizable()
                        .scaledToFill()
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }else{
                VStack{
                    HStack(alignment: .bottom){
                        Text("You lost a")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                        Text("342")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .cLightBrown)
                            .padding(.vertical, -5)
                        Text("days streak!")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                    }.padding(.bottom, 8)
                    
                    Spacer()
                    HStack(alignment: .bottom){
                        Text("You forgot to Poop?")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown)
                        Spacer()
                        ButtonPoop(text: "Restart")
                            .onTapGesture {
                                streak += 1
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical)
                .frame(maxWidth: .infinity, minHeight: 133)
                .background(
                    Image("StreakBreack")
                        .resizable()
                        .scaledToFill()
                    
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            
        }.padding(.horizontal, 20)
    }
}



struct ButtonPoop : View {
    var text: String
    
    var body: some View {
        HStack(spacing: 6){
            Image("DropAPoop")
                .renderingMode(.original)
                .resizable()
                .frame(width: 26, height: 26)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .accent)
        }.padding(.leading, 7).padding(.trailing, 8.5).padding(.vertical, 5)
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
    }
}
