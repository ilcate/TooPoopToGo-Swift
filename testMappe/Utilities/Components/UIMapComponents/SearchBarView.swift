//
//  SearchBarView.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var mapViewModel: MapModel
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        HStack {
            ZStack {
                HStack {
                    TextField("Search", text: $mapViewModel.searchingInput)
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                        .allowsHitTesting(mapViewModel.search ? true : false)
                        .padding(.trailing, -24)
                        .focused($isFocused)
                        .onTapGesture {
                            if isFocused {
                                isTexting.texting = true
                                isTexting.page = true
                            }
                        }
                        .onChange(of: isFocused) { _, newValue in
                            if !isFocused {
                                isTexting.page = false
                            }
                        }
                        .onChange(of: mapViewModel.searchingInput) { _, newValue in
                            if !newValue.isEmpty {
                                api.searchBathroom(stringToSearch: newValue) { resp in
                                    mapViewModel.searchedElements = resp
                                }
                            }
                        }
                }
                .frame(maxWidth: mapViewModel.search ? .infinity : 44)
                .padding(.horizontal, mapViewModel.search ? 16 : 0)
                .padding(.vertical, 9)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.accent, lineWidth: isFocused ? 3 : 0)
                )

                if !mapViewModel.search {
                    NavigationLink(destination: ProfileView(isYourProfile: true)) {
                        Image("Profile")
                            .uiButtonStyle(backgroundColor: .white)
                    }
                }
            }
            Spacer()

            Image(mapViewModel.search ? "Close" : "Search")
                .uiButtonStyle(backgroundColor: .white)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        mapViewModel.search.toggle()
                        mapViewModel.removeSelection()
                        if isTexting.texting {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            isTexting.texting = false
                        } else {
                            isTexting.page = false
                        }
                    }
                }
        }
        .padding(.top, 8)
    }
}
