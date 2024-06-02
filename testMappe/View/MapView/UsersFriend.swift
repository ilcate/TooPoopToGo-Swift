//
//  UsersFriend.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 02/06/24.
//

import SwiftUI

struct UsersFriend: View {
    @EnvironmentObject var api: ApiManager
    let id: String
    let isYourProfile: Bool
    let name: String
    @State var userList: [UserInfoResponse] = []
    
    var body: some View {
        VStack {
            ZStack{
                VStack{
                    HStack{
                        Text("Friends:")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                            .padding(.top, 8)
                        Spacer()
                    }.padding(.horizontal, 20)
                    
                    ScrollView {
                        LazyVStack {
                            ForEach($userList, id: \.id) { user in
                                UserClickable(user: user)
                            }
                        }
                    }
                    Spacer()
                }.padding(.top, 60)
                HeaderProfile(screenName: name)
            }
           
        }
        .navigationBarBackButtonHidden(true)
        .task {
            if isYourProfile {
                api.getMyFriends { result in
                    switch result {
                    case .success(let resp):
                        userList = resp
                    case .failure(let error):
                        print("Error fetching my friends: \(error)")
                    }
                }
            } else {
                api.getOtherFriends(id: id) { result in
                    switch result {
                    case .success(let resp):
                        userList = resp
                    case .failure(let error):
                        print("Error fetching other user's friends: \(error)")
                    }
                }
            }
        }
    }
}
