//
//  Settings.swift
//  testMappe
//
//  Created by Christian Catenacci on 16/05/24.
//

import SwiftUI
import Lottie

struct SettingsView: View {
    @EnvironmentObject var api : ApiManager
    @EnvironmentObject var onBoarding : OnBoarding
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        VStack{
            Text("LogOut")
                .onTapGesture {
                    api.clearToken()
                    onBoarding.onBoarding = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                }
            
        }.background(.black)
        
    }
}

