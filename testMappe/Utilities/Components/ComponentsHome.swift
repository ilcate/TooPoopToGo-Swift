

import SwiftUI

struct SliderNextToYou: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel: MapModel
    
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

struct StreakButtons: View {
    @ObservedObject var homeModel: HomeModel
    @EnvironmentObject var api: ApiManager
    
    var body: some View {
        VStack(spacing:6){
            HStack{
                Text("Streak")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
            }
            if homeModel.status == "active" || homeModel.status == "on_cooldown" {
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
                                
                                
                                if homeModel.status == "active"{
                                    ButtonPoop(text: "Drop a Poop")
                                        .onTapGesture {
                                            homeModel.updatePS(api: api)
                                        }
                                } else if  homeModel.status == "on_cooldown" {
                                    ButtonPoop(text: "Done")
                                    
                                }
                                
                            }
                            
                            Spacer()
                        }
                        
                    }.padding(.bottom, 16)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Text("\(homeModel.count)")
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
            } else if homeModel.status == "expired"  {
                VStack{
                    HStack(alignment: .bottom){
                        Text("You lost a")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                        Text("\(homeModel.count)")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .cLightBrown)
                            .padding(.vertical, -5)
                        Text("days streak!")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                        Spacer()
                    }.padding(.bottom, 8)
                    
                    Spacer()
                    HStack(alignment: .bottom){
                        Text("You forgot to Poop?")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown)
                        Spacer()
                        ButtonPoop(text: "Restart")
                            .onTapGesture {
                                homeModel.updatePS(api: api)
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
            }else{
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 132)
            }
            
            
        }.padding(.horizontal, 20)
           
    }
}



struct ButtonPoop : View {
    var text: String
    
    var body: some View {
        
        HStack(spacing: 6){
            if text != "Done"{
                Image("DropAPoop")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 26, height: 26)
            }
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: text != "Done" ? .accent : .white)
                .frame(height: 26)
        }.padding(.leading, text != "Done" ? 7 : 12).padding(.trailing, text != "Done" ? 8.5 : 12).padding(.vertical, 5)
            .background(text != "Done" ? .white : .cPurpura)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
        
    }
}
