//
//  FeedView.swift
//  testMappe
//
//  Created by Christian Catenacci on 26/04/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var api: ApiManager
    var body: some View {
        VStack{
            HeadersViewPages(PageName: "Feed")
            Spacer()
            
            ScrollView{
                VStack(spacing: 12){
                    FeedNotification(name: "Mistro.fino", time: "2h", badgeName: "", isFriendRequest: true)
                    FeedNotification(name: "MarelloPisello", time: "3h", badgeName: "one hundred days of poop streak", isFriendRequest: false)
                    

                
                }.padding(.top, 8)
            }
            
        }.background(.cLightBrown)
            .onAppear{
                api.searchUser(stringToSearch: "a") { resp in
                    print(resp)
                }
            }
    }
}

