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
    @State var uslessBool = false
    @State var status = "none"
    
    var body: some View {
        ZStack{
            VStack{
                UserInformationStandards(profilePicture: userSelected.photo_user!.replacingOccurrences(of: "http://", with: "https://"), isYourProfile: false, openSheetUploadImage: $uslessBool, username: userSelected.username, friendsNumber: userSelected.friends_number!, id: id, status : $status)
                OtherInformationUser()
                Spacer()
            }.task {
                api.statusFriendRequest(userId: id) { result in
                    print(result)
                    switch result {
                    case .success(let friendStatus):
                        status = friendStatus
                    case .failure:
                        status = "none"
                    }
                }
              
                
                api.getSpecificUser(userId: id) { resp in
                    switch resp {
                    case .success(let info):
                        userSelected = UserInfoResponse(username: info.username, photo_user: info.photo_user, id: id , friends_number: info.friends_number, badges: info.badges)
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    
                }
            } .navigationBarBackButtonHidden(true)
                .background(.cLightBrown)
            
            
            HeaderProfile(screenName: "Profile")
        }
        
        
    }
}
