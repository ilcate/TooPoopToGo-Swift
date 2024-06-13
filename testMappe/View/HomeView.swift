//
//  HomeView.swift
//  testMappe
//
//  Created by Christian Catenacci on 26/04/24.
//

//TODO: spostare tutta la logica dentro il model

//TODO: Importante dividi in pezzi Magari faccio la cartella home con tutti questi pezzettini

import SwiftUI
import CoreLocation

struct HomeView: View {
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel: MapModel
    @StateObject var homeModel = HomeModel()
    @State var friendReviews : [Review] = []

    
//    @State private var names = ["MistroFino", "Pisellone", "PerAssurdo", "Filippino"]
    @State private var streak = 0
    
    var body: some View {
        VStack{
            HeadersViewPages(PageName: "Home", mapViewModel: mapViewModel)
                .onAppear{
                    let locationManager = CLLocationManager()
                    locationManager.requestWhenInUseAuthorization()
                }
            Spacer()
            ScrollView{
                LazyVStack{
                    TipView()
                    
                    NextBadge()
                    
                    StreakButtons(homeModel: homeModel)
                    
                    SliderNextToYou(homeModel: homeModel, mapViewModel: mapViewModel)
                    
                    
                    HStack {
                        Text("Friends Reviews")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            .padding(.vertical, -1)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    ReviewsScroller(reviews: friendReviews, isProfile: false, isShort: false, mapViewModel: mapViewModel)
                        .padding(.bottom, 20)
                 
                    
                }
               
            }
            
            
        }.background(.cLightBrown)
            .task {
                homeModel.fetchPS(api: api)
                api.getRatingsOfFriends(){ resp in
                    switch resp {
                    case .success(let rev):
                         friendReviews = rev
                    case .failure(let error):
                        print(error)
                    }
                }
            }
    }
}
