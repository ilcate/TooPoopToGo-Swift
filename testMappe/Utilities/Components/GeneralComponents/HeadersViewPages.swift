//
//  HeadersViewPages.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct HeadersViewPages: View {
    var PageName: String
    
    
    var body: some View {
        HStack{
            NavigationLink(destination: ProfileView( isYourProfile: true)) {
                Image("Profile")
                    .uiButtonStyle(backgroundColor: .white)
            }
            Spacer()
            Text(PageName)
                .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
            Spacer()
            NavigationLink(destination: SettingsView()) {
                Image("Settings")
                    .uiButtonStyle(backgroundColor: .white)
            }
            
        }.padding(.horizontal, 20).padding(.top, 8)
    }
}
