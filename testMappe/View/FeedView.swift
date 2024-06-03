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
    @State var feedDisp : [ResultFeed] = []
    
    var body: some View {
        VStack {
            HeadersFeedView(isSearching: $isSearching , users: $users)
            Spacer()
            if !isSearching {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(feedDisp) { notification in
                            
                                FeedNotification(notification: notification)

                            
                        }
                       
                    }
                } .transition(.identity)
                    .padding(.top, 8)
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
            api.getFeed(id: api.userId) { resp in
                switch resp{
                case .success(let feed):
                    feedDisp = feed.results
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
}


