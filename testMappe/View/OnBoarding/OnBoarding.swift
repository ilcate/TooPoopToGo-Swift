//
//  OnBoarding.swift
//  testMappe
//
//  Created by Christian Catenacci on 17/05/24.
//

import SwiftUI

struct OnBoardingView: View {
    var PagesOnBoarding = ["Find", "Review", "More", "Pipo"]
    @State private var position : String?
    @State private var navigateToLogInAndSignUp = false
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                NavigationLink(destination: ChoseLogM()){
                    Text("Skip")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                        .underline()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
            Spacer()
            ZStack{
                ScrollView(.horizontal){
                    HStack(spacing: 0){
                        ForEach(PagesOnBoarding, id: \.self) { name in
                            VStack{
                                Image("ImagePlaceHolder3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 260, height: 340)
                                
                                VStack(spacing: 12){
                                    Text("\(name) fun in town")
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 26, fontColor: .accent)
                                    Text("Welcome to Too Poop To Go, your best firend when in need for a nice and comfy toilet!")
                                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                                        .padding(.horizontal, 36)
                                        .multilineTextAlignment(.center)
                                    
                                }.padding(.top, 28)
                                
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                            .padding(.trailing, 10)
                            
                        }
                    }
                    .padding(.trailing, -10)
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $position, anchor: .leading)
                .contentMargins(20, for: .scrollContent)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .padding(.bottom, 32)
                
                
                VStack{
                    Spacer()
                    HStack(spacing: 6) {
                        ForEach(PagesOnBoarding, id: \.self) { imageName in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(imageName == position ? .accent : Color.cLightBrown50)
                            
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 3.5)
                    
                    
                    
                }
                .padding(.bottom, 8)
                
            }
            
            
            
            Spacer()
            
            FullRoundedButton(text: position == PagesOnBoarding[PagesOnBoarding.count - 1] ? "Start" : "Next")
                .onTapGesture {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { //serve per far si che non ci siano dei bug grafici
                        withAnimation(.easeInOut(duration: 0.1)) {
                            if let indexOfA = PagesOnBoarding.firstIndex(of: position!) {
                                let nextIndex = indexOfA + 1
                                if nextIndex < PagesOnBoarding.count {
                                    position = PagesOnBoarding[nextIndex]
                                }else {
                                    navigateToLogInAndSignUp = true
                                }
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $navigateToLogInAndSignUp) {
                    ChoseLogM()
                }
            
            //TODO: chiedi ad alby i fix della home
            
            
        }.background(.cLightBrown)
            .onAppear{
                position = PagesOnBoarding[0]
            }
        
    }
}
