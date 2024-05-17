//
//  LogInAndSignUp.swift
//  testMappe
//
//  Created by Christian Catenacci on 17/05/24.
//


import SwiftUI

struct LogInAndSignUp: View {
    @EnvironmentObject var onBoarding: OnBoarding
    @Environment(\.dismiss) var dismiss


    @State var isLogIn : Bool
    @State private var username = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            HStack{
                Text(!isLogIn ? "Create Account" : "Log In")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 32, fontColor: .accent)
                Spacer()
            }  .padding(.horizontal, 20).padding(.bottom, 6)
            
            VStack{
                TextFieldCustom(stateVariable: $username, name: "Username")
                if !isLogIn {
                    TextFieldCustom(stateVariable: $firstName, name: "First name")
                    TextFieldCustom(stateVariable: $lastName, name: "Last name")
                    TextFieldCustom(stateVariable: $email, name: "Email")
                }
                TextFieldCustom(stateVariable: $password, name: "Password")
                
            }.padding(.horizontal, 20)
            
            Spacer()
            Text(!isLogIn ? "You are already registered? Log In" : "Don't have an account? Log In")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                .onTapGesture {
                    isLogIn.toggle()
                }
            FullRoundedButton(text: !isLogIn ? "Join now!" : "Log In")
                .onTapGesture {
                    onBoarding.onBoarding = true
                    dismiss()//TODO: bisonga fare un pop to root
                }
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 8)
        .background(.cLightBrown)
    }
}

#Preview {
    LogInAndSignUp(isLogIn: false)
}
