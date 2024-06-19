//
//  ComponentsProfile.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 01/06/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

struct UserInformationStandards: View {
    @EnvironmentObject var api: ApiManager
    var profilePicture : String
    let isYourProfile : Bool
    @Binding var openSheetUploadImage : Bool
    let username : String
    let friendsNumber: Int
    let id: String
    @Binding var status: RequestStatus
    @EnvironmentObject var mapViewModel: MapModel
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                ZStack {
                    ProfileP(link: profilePicture, size: 70, padding: 20)
                    if isYourProfile {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image("Edit")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 26, height: 26)
                            }
                        }
                    }
                }
                .frame(width: 70, height: 70)
                .padding(.leading, 10)
                .onTapGesture {
                    if isYourProfile{
                        openSheetUploadImage = true
                    }
                }
                VStack(alignment: .leading) {
                    Text(username.capitalized)
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 32, fontColor: .accent)
                        .padding(.bottom, -2)
                    HStack{
                        if !isYourProfile &&  status.request_status != "pending" && status.request_status  != "accepted" {
                            VStack{
                                Text("Send Request")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                api.sendFriendRequest(userId: id)
                                status.request_status  = "pending"
                            }
                        } else if !isYourProfile && status.request_status  != "accepted" && status.request_status  == "pending" {
                            VStack{
                                Text("Request Sent")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .white).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.cLightBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            
                        } else if !isYourProfile && status.request_status  == "accepted" && status.request_status  != "pending" {
                            VStack{
                                Text("Remove Friend")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .white).padding(.horizontal, 10).padding(.vertical, 2)
                                    .onTapGesture{
                                        api.removeFriend(userId: status.friend_request_id)
                                        status.request_status = "none"
                                    }
                                
                            }
                            .background(.cLightBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }
                        
                        if friendsNumber > 0 {
                            NavigationLink(destination: UsersFriend(id: id, isYourProfile: isYourProfile, name: username)) {
                                Text("\(friendsNumber) Friends")
                                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                            }
                        } else {
                            Text("\(friendsNumber) Friends")
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                        }
                    }
                    
                }
                .padding(.leading, 16)
                
                Spacer()
            }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(Color.white)
        .ignoresSafeArea()
        
    }
}

struct OtherInformationUser: View {
    @EnvironmentObject var api: ApiManager
    @ObservedObject var profileModel : ProfileModel
    @EnvironmentObject var mapViewModel: MapModel
    let isYourself : Bool
    let userId : String
    
    var body: some View {
        VStack(spacing: 12) {
            if profileModel.loadedBadge && profileModel.loadedRatings && profileModel.loadedToilet {
                VStack(spacing: 8) {
                    HStack {
                        Text("Badges")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Spacer()
                    } .padding(.horizontal, 20)
                    if !profileModel.userBadges.isEmpty{
                        ScrollView(.horizontal){
                            LazyHStack {
                                ForEach(profileModel.userBadges, id: \.self) { badge in
                                    VStack {
                                        if let imageURL = URL(string: "\(api.url)\(badge.badge_photo ?? "")") {
                                            WebImage(url: imageURL, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                                                .resizable()
                                                .frame(width: 58, height: 58)
                                                .applyGrayscale(badge.is_completed ? 0 : 1)
                                        }
                                        Text(badge.badge_name)
                                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 12, fontColor: .accent)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    .padding(8)
                                    .frame(width: 80)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.bottom, 8)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            .frame(height: 105)
                           
                        }.padding(.bottom, -14)
                    }else{
                        Text("No badge completed")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 20)
                            
                    }
                   
                
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Reviews")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Spacer()
                    } .padding(.horizontal, 20)
                    ReviewsScroller(reviews: profileModel.userRatings, isProfile: true, isShort: false)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Toilet Created")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Spacer()
                    } .padding(.horizontal, 20)
                    if !profileModel.userToilet.isEmpty {
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(profileModel.userToilet, id: \.self) { bathroom in
                                        InformationOfSelectionView(bathroom: bathroom, mapViewModel: mapViewModel)
                                            .padding(.vertical, 3)
                                            .frame(width: 350)
                                    }
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .scrollTargetLayout()
                            }
                            .contentMargins(0, for: .scrollContent)
                            .scrollIndicators(.hidden)
                            .scrollTargetBehavior(.viewAligned)
                        }
                        .padding(.vertical, -1)
                    } else {
                        Text("No bathroom created")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 114)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 20)
                            
                    }
                }
            } else {
                VStack{
                    Spacer()
                    LottieView(animation: .named("LoadingAnimation.json"))
                        .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                        .frame(width: 90, height: 90)
                    Spacer()
                }
                
            }
            
        }
        .padding(.top, -48)
       
        .task {
            profileModel.getToilets(api: api, isSelf: isYourself)
            profileModel.getBadges(api: api, isSelf: isYourself)
            profileModel.getReviews(api: api, isSelf: isYourself)
        }
    }
}

struct HeaderProfile: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    let screenName: String
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Image("BackArrow")
                    .uiButtonStyle(backgroundColor: name == "" ? .white : .cLightBrown)
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                
                Text(screenName)
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                    .padding(.trailing, name.isEmpty ? 44 : 0)
                Spacer()
                
                if !name.isEmpty {
                    ShareLink(item: "Hi, search for @\(name) in Too Poop To Go; it's worth it, I promise.🥺💩") {
                        Image("Share")
                            .uiButtonStyle(backgroundColor: .cLightBrown)
                    }
                }
            }
            .padding(.top, 8)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}


struct UserClickable: View {
    @Binding var user: UserInfoResponse
    @EnvironmentObject var api: ApiManager
    
    var body: some View {
        NavigationLink(destination: ProfileView(id: user.id, isYourProfile: user.id == api.personalId ? true : false)) {
            HStack {
                ProfileP(link: user.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "", size: 40, padding: 0)
                    .padding(.trailing, 8)
                    .padding(.leading, 12)
                Text(user.username.capitalized)
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                    .padding(.bottom, 1)
                Spacer()
                Image("LightArrow")
                    .resizable()
                    .rotationEffect(.degrees(90))
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 12)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 20)
        }
    }
}
