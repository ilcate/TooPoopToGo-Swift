import SwiftUI

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
                                            homeModel.scheduleNotificationForNextDay()
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
                    Image("StreakGoing")
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
