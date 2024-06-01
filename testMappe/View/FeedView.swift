//
//  FeedView.swift
//  testMappe
//
//  Created by Christian Catenacci on 26/04/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @State var isSearching = false
    @State var users : [UserInfoResponse] = []
    
    var body: some View {
        VStack {
            HeadersFeedView(isSearching: $isSearching , users: $users)
            Spacer()
            if !isSearching {
                ScrollView {
                    VStack(spacing: 2) {
                        FeedNotification(name: "Mistro.fino", id: "", time: "2h", badgeName: "", isFriendRequest: true)
                        FeedNotification(name: "MarelloPisello", id: "", time: "3h", badgeName: "one hundred days of poop streak", isFriendRequest: false)
                            .padding(.top, 8)
                        
                    }
                } .transition(.identity)
            } else {
                ScrollView {
                    ForEach(users) { user in
                        LazyVStack(spacing: 2) {
                            NavigationLink(destination: FriendsProfileView(id: user.id )) {
                                HStack {
                                    ProfileP(link: user.photo_user ?? "", size: 40, padding: 0)
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
                            .padding(.top, 8)
                        }
                    }
                }
                .transition(.identity)

            }
        }
        .background(Color.cLightBrown)
        .animation(.easeOut(duration: 0.2), value: isSearching)
    }
}
