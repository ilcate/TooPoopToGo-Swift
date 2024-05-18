//
//  Loader.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 18/05/24.
//

import SwiftUI

struct Loader: View {
    @State var isAnimating = false
    @EnvironmentObject var api : ApiManager

    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    Circle()
                        .fill(.cMidBrown.opacity(0.2))
                        .frame(width: 250)
                    HStack(spacing: 90){
                        Circle()
                            .fill(.cMidBrown.opacity(0.2))
                            .frame(width: 250)
                        
                        Circle()
                            .fill(.cMidBrown.opacity(0.2))
                            .frame(width: 250)
                            
                    }.padding(.vertical, -20)
                    Circle()
                        .fill(.cMidBrown.opacity(0.2))
                        .frame(width: 250)
                }
//                .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: isAnimating)
//                .onAppear {
//                    self.isAnimating = true
//                }//TODO: Non va l'animazione
                
                VStack{
                    Image("WhiteLogo")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, -35)
                    Text("Too Poop To Go")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .white)
                    Text("Setting up all your preferences, \n please wait...")
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.4))
            
            
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)

        .background(.accent)
        
    }
}
