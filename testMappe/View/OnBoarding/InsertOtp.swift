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
                Spacer()
            
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 6)
            
            Spacer()
            
            TextFieldCustom(stateVariable: $otp, name: "Otp")
                .padding(.horizontal, 20)
            
            Spacer()
            
            FullRoundedButton(text: "Confirm Account")
                .onTapGesture {
                    let otpToSend = SendOtp(otp: otp, email: api.email)
                   
                    api.activateAccount(parameters: otpToSend){ result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                onBoarding.onBoarding = true
                                path.removeAll()
                                let loginInfo = LogInInformation(username: api.username, password: api.password)
                                api.getToken(userData: loginInfo){ result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let token):
                                            api.saveToken(token: token)
                                        case .failure(_):
                                            path.append("LogIn")
                                            onBoarding.onBoarding = false
                                        }
                                    }
                                }
                            case .failure(let error):
                                print("sorry but no \(error)")
                            }
                        }
                    }
                    
                }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(Color.cLightBrown)
    }
}

