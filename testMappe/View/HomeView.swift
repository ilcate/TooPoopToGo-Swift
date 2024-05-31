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
    
//    @State private var names = ["MistroFino", "Pisellone", "PerAssurdo", "Filippino"]
    @State private var streak = 0
    
    var body: some View {
        VStack{
            HeadersViewPages(PageName: "Home")
                .onAppear{
                    let locationManager = CLLocationManager()
                    locationManager.requestWhenInUseAuthorization()
                }
            Spacer()
            ScrollView{
                LazyVStack{
                    VStack{
                        HStack{
                            HStack(spacing: 2){
                                Image("Advice")
                                    .renderingMode(.original)
                                Text("Daily Advice")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 12, fontColor: .accent)
                            }
                            .padding(.leading, 7).padding(.trailing, 6).padding(.vertical, 1)
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                            Spacer()
                            
                            
                        }.padding(.leading, 16).padding(.top, 16)
                        Spacer()
                        VStack{
                            HStack{
                                Text("Mind Your Fiber Intake")
                                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                                Spacer()
                            }.padding(.leading, 4)
                            Text("Incorporate fiber-rich foods like fruits, vegetables, and whole grains into your diet to promote smooth and effortless pooping.")
                                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 13, fontColor: .accent)
                        }.padding(.horizontal, 15).padding(.bottom, 8)
                        
                        
                        Spacer()
                    }.background(
                        Image("ImagePlaceHolder6")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 170)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    )
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, maxHeight: 170)
                    .padding(.top, 8)
                    
                    VStack(spacing: 6){
                        HStack{
                            Text("Next badge")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            Spacer()
                        }
                        HStack{
                            VStack(alignment: .leading, spacing: -16){
                                Text("Reviews Writer")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                                Text("80%")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 48, fontColor: .accent)
                            }.padding(.leading, 16).padding(.top, 6)
                            Spacer()
                            Image("ImagePlaceHolder7")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 60 , height: 60)
                                .padding(.trailing, 16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 86)
                        .background(.cLightBrown50)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }.padding(.horizontal, 20)
                    
                    
                    StreakButtons(streak: streak)
                    
                    SliderNextToYou(homeModel: homeModel, mapViewModel: mapViewModel)
                    
//                    VStack(spacing: 6){
//                        HStack{
//                            Text("Friends Reviews")
//                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
//                            Spacer()
//                        }.padding(.horizontal, 20)
//                        ReviewsScroller(reviews: names)
//                    }.padding(.bottom, 12)
                    
                }
            }
            
            
        }.background(.cLightBrown)
    }
}
