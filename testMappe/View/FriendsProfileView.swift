//
//  FriendsProfileView.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 01/06/24.
//

import SwiftUI

struct FriendsProfileView: View {
    @EnvironmentObject var api: ApiManager
    @State var id : String
    @State var userSelected = UserInfoResponse(username: "Loading...", photo_user: "", id: "" , friends_number: 0, badges: [""])
    @State var uslessBool = false
    @State var status = RequestStatus(request_status: "none", friend_request_id: "")
    @StateObject var profileModel = ProfileModel()
    @ObservedObject var mapViewModel : MapModel
    
    var body: some View {
        ZStack{
            VStack{
                UserInformationStandards(profilePicture: userSelected.photo_user!.replacingOccurrences(of: "http://", with: "https://"), isYourProfile: false, openSheetUploadImage: $uslessBool, username: userSelected.username, friendsNumber: userSelected.friends_number!, id: userSelected.id, status : $status, mapViewModel: mapViewModel)
                OtherInformationUser(profileModel: profileModel, mapViewModel: mapViewModel, isYourself: false ,userId: userSelected.id)
                Spacer()
            }.task {
                api.getSpecificUser(userId: id) { resp in
                    switch resp {
                    case .success(let info):
                        userSelected = UserInfoResponse(username: info.username, photo_user: info.photo_user, id: info.id , friends_number: info.friends_number, badges: info.badges)
                        profileModel.userInfo.id = userSelected.id
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    
                }
                api.statusFriendRequest(userId: id) { result in
                    switch result {
                    case .success(let friendStatus):
                        status = RequestStatus(request_status: friendStatus.request_status, friend_request_id: friendStatus.friend_request_id)
                    case .failure:
                        status = RequestStatus(request_status: "none", friend_request_id: "")
                    }
                }
        
            } .navigationBarBackButtonHidden(true)
                .background(.cLightBrown)
            
            HeaderProfile(screenName: "Profile" , name: userSelected.username)
        }
        
        
    }
}
