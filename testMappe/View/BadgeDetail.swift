//
//  BadgeDetail.swift
//  testMappe
//
//  Created by Christian Catenacci on 16/05/24.
//

import SwiftUI

struct BadgeDetail: View {
    @Environment(\.dismiss) var dismiss
    var maxProgression = 12.0
    var currentProgress = 10.0
    
    @State var isAnimating = false

    
    
    var body: some View {
        

        ZStack{
            
            
                Image("Lights")
                    .resizable()
                    .renderingMode(.original)
                    .frame(maxWidth: 800, maxHeight: 800)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear {
                        self.isAnimating = true
                    }
            
                    .padding(.top, -300)
                //.animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            VStack{
                HStack{
                    NavigationLink(destination: ProfileView()) {
                        Image("BackArrow")
                            .uiButtonStyle(backgroundColor: .white)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    Spacer()
                    Text("Badge")
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image("Share")
                            .uiButtonStyle(backgroundColor: .white)
                    }
                    
                }.padding(.top, 8)
                //Spacer()
                
                
                Image("ImagePlaceHolder7")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 220, height: 220)
        
                
                HStack{
                    Text("Review Writer")
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                    Spacer()
                }.padding(.top, 12)
                
                ZStack{
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.cMidBrown)
                            .frame(maxWidth: geometry.size.width, maxHeight: 26 )
                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                        Rectangle()
                            .fill(.accent)
                            .frame(maxWidth: geometry.size.width * (currentProgress/maxProgression), maxHeight: 26 )
                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                    }.frame(height: 26)
                    
                    HStack{
                        Text("Progression")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 12, fontColor: .cLightBrown)
                        Spacer()
                        Text("\(Int(currentProgress))/\(Int(maxProgression))")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 12, fontColor: .cLightBrown)
                    }
                    .padding(.horizontal, 16)
                    
                    
                }.padding(.top, -20)
                
                HStack{
                    Spacer()
                    VStack{
                        Text("Type")
                            .normalTextStyle(fontName: "Manrope-Regular", fontSize: 15, fontColor: .accent)
                        Text("Poet")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                    }
                    Spacer()
                    Rectangle()
                        .fill(.cUltraLightGray)
                        .frame(maxWidth:  2, maxHeight: .infinity )
                    Spacer()
                    VStack{
                        Text("Difficulty")
                            .normalTextStyle(fontName: "Manrope-Regular", fontSize: 15, fontColor: .accent)
                        Text("Hard")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                    }
                    .padding(.horizontal, -7)
                    
                   
                    Spacer()
                    Rectangle()
                        .fill(.cUltraLightGray)
                        .frame(maxWidth:  2, maxHeight: .infinity )
                    Spacer()
                    VStack{
                        Text("Only")
                            .normalTextStyle(fontName: "Manrope-Regular", fontSize: 15, fontColor: .accent)
                        Text("23%")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.cUltraLightGray, lineWidth: 2)
                )
                
                HStack{
                    Text("How to get?")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                    Spacer()
                }
                HStack{
                    Text("To acquire this badge, it is necessary to assess twelve distinct bathrooms on twelve distinct days, all located at least 100 meters apart from each other.")
                        .normalTextStyle(fontName: "Manrope-Regular", fontSize: 16, fontColor: .accent)
                    Spacer()
                }
              
                            
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
           
        }.background(.cLightBrown)
       
        
        FullRoundedButton(text: "Bring me to the map")
            .background(.cLightBrown)
    }
}

#Preview {
    BadgeDetail()
}
