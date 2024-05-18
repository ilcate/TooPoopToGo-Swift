//
//  InsertOtp.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 18/05/24.
//

import SwiftUI

struct InsertOtp: View {
    @EnvironmentObject var api : ApiManager
    @EnvironmentObject var onBoarding : OnBoarding
    @State private var otp = ""
    @Binding var path: [String]
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Insert otp")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
            
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 6)
            
            Spacer()
            
            TextFieldCustom(stateVariable: $otp, name: "Username")
                .padding(.horizontal, 20)
            
            Spacer()
            
            FullRoundedButton(text: "Confirm Account")
                .onTapGesture {
                    let otpToSend = SendOtp(otp: otp, email: "kryscc03@gmail.com")
                    onBoarding.onBoarding = true
                    path.removeAll()
                    api.activateAccount(parameters: otpToSend)
                    
                }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(Color.cLightBrown)
    }
}

