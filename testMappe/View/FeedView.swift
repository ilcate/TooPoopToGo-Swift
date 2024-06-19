//
//  FeedView.swift
//  testMappe
//
//  Created by Christian Catenacci on 26/04/24.
//

import SwiftUI
import Lottie

struct FeedView: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @StateObject var feedModel = FeedModel()
    @State var isSearching = false
    @State var users : [UserInfoResponse] = []
    @State var feedDisp : [ResultFeed] = []
    
    
    var body: some View {
        VStack {
            HeadersFeedView( isSearching: $isSearching, users: $users)
            Spacer()
            if !isSearching {
                if feedModel.feedToDisplay.isEmpty{
                    VStack{
                        Spacer()
                        Text("Nothing here, try to do something")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accent)
                            .padding(.bottom, 8)
                    }
              
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(feedModel.feedToDisplay) { notification in
                                FeedNotification(notification: notification, feedModel: feedModel )

                            }
                           
                        }.padding(.bottom, 12)
                    } .transition(.identity)
                        .padding(.top, 8)
                    
                }
                
            } else {
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach($users) { user in
                            UserClickable(user: user)
                           
                        }
                    } .padding(.top, 8)
                }
                .transition(.identity)

            }
        }
        .background(Color.cLightBrown)
        .animation(.easeOut(duration: 0.2), value: isSearching)
        .task {
            feedModel.getFeedUpdated(api: api)
        }
    }
}


