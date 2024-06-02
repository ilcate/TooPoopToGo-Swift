//
//  ComponentsProfile.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 01/06/24.
//

import SwiftUI

struct UserInformationStandards: View {
    @EnvironmentObject var api: ApiManager
    var profilePicture : String
    let isYourProfile : Bool
    @Binding var openSheetUploadImage : Bool
    let username : String
    let friendsNumber: Int
    let id: String
    @Binding var status: String
    
    
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
                        if !isYourProfile &&  status != "pending" && status != "accepted" {
                            VStack{
                                Text("Send Request")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                api.sendFriendRequest(userId: id)
                                status = "pending"
                            }
                        } else if !isYourProfile && status != "accepted" && status == "pending" {
                            VStack{
                                Text("Request Sent")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .white).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.cLightBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            
                        } else if !isYourProfile && status == "accepted" && status != "pending" {
                            VStack{
                                Text("Remove Friend")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .white).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.cLightBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }
                        
                        
                        Text("\(friendsNumber) Friends")
                            .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
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
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                HStack {
                    Text("Badges")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                    Spacer()
                }
                Text("You don't have any badge")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(spacing: 8) {
                HStack {
                    Text("Recents Reviews")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                    Spacer()
                }
                Text("Go to review your first bathroom")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(spacing: 8) {
                HStack {
                    Text("Recents Notifications")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                    Spacer()
                }
                Text("C'mon, try to do something")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, -48)
        .padding(.horizontal, 20)
    }
}

struct HeaderProfile: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    let screenName : String
    
    var body: some View {
        VStack {
            HStack {
                Image("BackArrow")
                    .uiButtonStyle(backgroundColor: .cLightBrown)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Text(screenName)
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                
                Spacer()
                NavigationLink(destination: SettingsView()) {
                    Image("Share")
                        .uiButtonStyle(backgroundColor: .cLightBrown)
                }
            }
            .padding(.top, 8)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}



