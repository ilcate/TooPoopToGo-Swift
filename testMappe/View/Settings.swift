//
//  Settings.swift
//  testMappe
//
//  Created by Christian Catenacci on 16/05/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var api : ApiManager
    var body: some View {
        Text("LogOut")
            .onTapGesture {
                api.clearToken()
                
            }
    }
}

