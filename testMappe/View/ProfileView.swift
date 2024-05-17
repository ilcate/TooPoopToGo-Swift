//
//  ProfileView.swift
//  testMappe
//
//  Created by Christian Catenacci on 03/05/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
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
                Text("Profile")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                Spacer()
                NavigationLink(destination: SettingsView()) {
                    Image("Share")
                        .uiButtonStyle(backgroundColor: .white)
                }
                
            }.padding(.top, 8)
            Spacer()
        }
        
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
        
        .background(.cLightBrown)
    }
}
