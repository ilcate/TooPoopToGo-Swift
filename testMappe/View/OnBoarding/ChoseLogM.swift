//
//  ChoseLogM.swift
//  testMappe
//
//  Created by Christian Catenacci on 17/05/24.
//

import SwiftUI

struct ChoseLogM: View {
    @State private var haveAnAccount = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Too Poop To Go")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                Spacer()
            }  .padding(.horizontal, 20)
            Spacer()
            VStack(spacing: 8){
                NavigationLink(destination: LogInAndSignUp(isLogIn: true)) {
                    FullRoundedButton(text: "Log In")
                }
                
                NavigationLink(destination: LogInAndSignUp(isLogIn: false)) {
                    FullRoundedButton(text: "Sign Up")
                }
                //FullRoundedButton(text: "Sign Up with Google")
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(.cLightBrown)
       
    }
}

#Preview {
    ChoseLogM()
}
