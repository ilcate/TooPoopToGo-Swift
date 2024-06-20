//
//  FeedNotification.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 20/06/24.
//

import SwiftUI

struct FeedNotification : View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var tabBarSelection: TabBarSelection
    var notification : ResultFeed
    @State var userInformation = UserInfoResponse(username: "", id: "")
    @ObservedObject var feedModel : FeedModel
    
    
    @State var bathroom =  BathroomApi()
    
    var body: some View {
        VStack{
            HStack{
                if  notification.content_type == "friend_request" {
                    NavigationLink(destination: {
                        if userInformation.id == api.personalId {
                            ProfileView( isYourProfile: true)
                        } else {
                            ProfileView( id: userInformation.id, isYourProfile: false)
                        }
                    }) {
                        ProfileP(link: userInformation.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "" , size: 44, padding: 0)
                            .padding(.bottom, -28)
                        VStack(alignment: .leading, spacing: -1.5){
                            Text(userInformation.username)
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                                .padding(.top, 20)
                            Text(notification.content)
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .accent)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    
                } else {
                    Image("Aicon")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: -1.5){
                        Text(  "Notice" )
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                            .padding(.top, 20)
                        Text(notification.content)
                            .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .accent)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                
            }
            .padding(.bottom, 12)
            .padding(.top, -10)
            .padding(.horizontal, 16)
            
            HStack(alignment: .bottom){
                Text(timeElapsedSince(notification.created_at, shortFormat: true))
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .cLightBrown50)
                    .padding(.bottom, -2.5)
                Spacer()
                if notification.friend_request?.request_status != nil && notification.content_type == "friend_request" {
                    if notification.friend_request!.request_status == "accepted" {
                        ButtonFeed(text: "Accepted")
                    }else{
                        ButtonFeed(text: "Accept")
                            .onTapGesture {
                                feedModel.acceptFriendRequest(api: api, id: notification.friend_request!.id) { res in
                                    switch res {
                                    case .success:
                                        feedModel.getFeedUpdated(api: api)
                                    case .failure:
                                        print("failed")
                                    }
                                }
                                
                            }
                        ButtonFeed(text: "Decline")
                            .onTapGesture {
                                feedModel.rejectFriendRequest(api: api, id: notification.friend_request!.id) { res in
                                    switch res {
                                    case .success:
                                        feedModel.getFeedUpdated(api: api)
                                    case .failure:
                                        print("failed")
                                        
                                        
                                    }
                                }
                            }
                        
                    }
                    
                } else if notification.content_type == "badge_update" {
                    ButtonFeed(text: "View Badges")
                        .onTapGesture {
                            self.tabBarSelection.selectedTab = 3
                            self.tabBarSelection.selectedBadge = notification.badge!.badge_name
                        }
                    
                } else if notification.content_type == "toilet_approved"{
                    NavigationLink(destination: DetailBathroom( bathroom: bathroom)){
                        ButtonFeed(text: "View Bathroom")
                            .onAppear{
                                feedModel.getSpecificBathroom(api: api, id: notification.toilet!.id) { res in
                                    switch res{
                                    case .success(let rsponse):
                                        bathroom = BathroomApi(id: rsponse.id, photos: rsponse.photos, name: rsponse.name, address: rsponse.address, coordinates: rsponse.coordinates, place_type: rsponse.place_type, is_for_disabled: rsponse.is_for_disabled, is_free: rsponse.is_free, is_for_babies: rsponse.is_for_babies, tags: rsponse.tags, updated_at: rsponse.updated_at)
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .task {
            if notification.content_type == "friend_request" && notification.friend_request != nil {
                api.getSpecificUser(userId: notification.friend_request!.from_user) { userRetrieve in
                    switch userRetrieve {
                    case .success(let user):
                        userInformation = user
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
