//
//  SearchView.swift
//  testMappe
//
//  Created by Christian Catenacci on 03/05/24.
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var isTexting: IsTexting

    
    var body: some View {
        Text("Search")
            .onAppear{
                isTexting.page = true
            }
            .onDisappear{
                isTexting.page = false
            }
            .toolbar(.hidden, for: .tabBar)
    }
}

