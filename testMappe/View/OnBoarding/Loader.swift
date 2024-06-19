//
//  Loader.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 18/05/24.
//

import SwiftUI
import Lottie

struct Loader: View {
    @State var isAnimating = false
    @EnvironmentObject var api : ApiManager
    let text : String

    
    var body: some View {
        VStack{
            ZStack{
                LottieView(animation: .named("LoadingScreen3.json"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                    })
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack{
                    Image("WhiteLogo")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, -35)
                    Text("Too Poop To Go")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .white)
                    Text(text)
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
