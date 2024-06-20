//
//  HeadersFeedView.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct HeadersFeedView: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @FocusState private var isFocused: Bool
    @Binding var isSearching: Bool
    @Binding var users: [UserInfoResponse]
    @State var field = ""
    
    var body: some View {
        HStack {
            ZStack{
                TextField("Search friends!", text: $field)
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                    .padding(.trailing, -24)
                    .focused($isFocused)
                    .onTapGesture {
                        isTexting.texting = true
                        isTexting.page = true
                    }
                    .onChange(of: field) { oldValue, newValue in
                        if !newValue.isEmpty {
                            api.searchUser(stringToSearch: field) { resp in
                                switch resp {
                                case .success(let us):
                                    users = us.results!
                                    print(users)
                                case .failure(let error):
                                    print("Error: \(error)")
                                }
                            }
                        } else {
                            users.removeAll()
                        }
                    }
                    .onChange(of: isFocused) { oldValue, newValue in
                        if !isFocused {
                            isTexting.page = false
                        }
                    }
                
                    .frame(maxWidth: isSearching ? .infinity : 44)
                    .padding(.horizontal, isSearching ? 16 : 0)
                    .padding(.vertical, 9)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(.accent, lineWidth: isFocused ? 3 : 0)
                    )
                
                if !isSearching {
                    HStack{
                        NavigationLink(destination:  ProfileView( isYourProfile: true)) {
                            Image("Profile")
                                .uiButtonStyle(backgroundColor: .white)
                        }
                        
                    }
                    
                }
                
            }
            Spacer()
            if !isSearching {
                Text("Feed")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
            }
            Spacer()
            Image(isSearching ? "Close" : "Search")
                .uiButtonStyle(backgroundColor: .white)
                .onTapGesture {
                    
                    if isTexting.texting == true {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isTexting.texting = false
                    } else {
                        isTexting.page = false
                    }
                    
                    withAnimation(.easeOut(duration: 0.2)) {
                        isSearching.toggle()
                    }
                    
                    if isSearching == false {
                        users.removeAll()
                    }
                    
                }
        }.padding(.horizontal, 20).padding(.top, 8)
    }
}
