//
//  ChoseLogM.swift
//  testMappe
//
//  Created by Christian Catenacci on 17/05/24.
//

import SwiftUI

struct ChoseLogM: View {
    @State private var haveAnAccount = false
    @Environment(\.dismiss) var dismiss
    @Binding var path: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text("Too Poop To Go")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            .padding(.horizontal, 20)
            Spacer()
            VStack(spacing: 8) {
                FullRoundedButton(text: "Log In")
                    .onTapGesture {
                        path.append("LogIn")
                    }
                
                FullRoundedButton(text: "Sign Up")
                    .onTapGesture {
                        path.append("SignUp")
                    }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(Color.cLightBrown)
    }
}
