//
//  FriendsProfileView.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 01/06/24.
//

import SwiftUI

struct FriendsProfileView: View {
    @EnvironmentObject var api: ApiManager
    let id : String
    @State var userSelected = UserInfoResponse(username: "", photo_user: "", id: "" , friends_number: 0, badges: [""])
    
    
    var body: some View {
        VStack{
            Text(userSelected.username)
                .padding(.bottom, 20)
            
            Text("send friend request")
                .onTapGesture {
                    api.sendFriendRequest(userId: id)
                }
        }.task {
            api.getSpecificUser(userId: id) { resp in
                switch resp {
                case .success(let info):
                    userSelected = UserInfoResponse(username: info.username, photo_user: info.photo_user, id: id , friends_number: info.friends_number, badges: info.badges)
                case .failure(let error):
                    print("Error: \(error)")
                }
              
            }
        }
        
    }
}
