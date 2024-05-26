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
    @StateObject var homeModel = HomeModel()
    
    @State private var names = ["MistroFino", "Pisellone", "PerAssurdo", "Filippino"]
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
                //                LazyVStack{
                //                    VStack{
                //                        HStack{
                //                            HStack(spacing: 2){
                //                                Image("Advice")
                //                                    .renderingMode(.original)
                //                                Text("Daily Advice")
                //                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 12, fontColor: .accent)
                //                            }
                //                            .padding(.leading, 7).padding(.trailing, 6).padding(.vertical, 1)
                //                            .background(.ultraThickMaterial)
                //                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                //                            Spacer()
                //
                //
                //                        }.padding(.leading, 16).padding(.top, 16)
                //                        Spacer()
                //                        VStack{
                //                            HStack{
                //                                Text("Mind Your Fiber Intake")
                //                                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                //                                Spacer()
                //                            }.padding(.leading, 4)
                //                            Text("Incorporate fiber-rich foods like fruits, vegetables, and whole grains into your diet to promote smooth and effortless pooping.")
                //                                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 13, fontColor: .accent)
                //                        }.padding(.horizontal, 15).padding(.bottom, 8)
                //
                //
                //                        Spacer()
                //                    }.background(
                //                        Image("ImagePlaceHolder6")
                //                            .resizable()
                //                            .scaledToFill()
                //                            .frame(maxWidth: .infinity, maxHeight: 170)
                //                            .clipShape(RoundedRectangle(cornerRadius: 16))
                //                    )
                //                    .padding(.horizontal, 20)
                //                    .frame(maxWidth: .infinity, maxHeight: 170)
                //                    .padding(.top, 8)
                //
                //
                //                    VStack(spacing: 6){
                //                        HStack{
                //                            Text("Next badge")
                //                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                //                            Spacer()
                //                        }
                //                        HStack{
                //                            VStack(alignment: .leading, spacing: -16){
                //                                Text("Reviews Writer")
                //                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                //                                Text("80%")
                //                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 48, fontColor: .accent)
                //                            }.padding(.leading, 16).padding(.top, 6)
                //                            Spacer()
                //                            Image("ImagePlaceHolder7")
                //                                .resizable()
                //                                .renderingMode(.original)
                //                                .frame(width: 60 , height: 60)
                //                                .padding(.trailing, 16)
                //                        }
                //                        .frame(maxWidth: .infinity, maxHeight: 86)
                //                        .background(.cLightBrown50)
                //                        .clipShape(RoundedRectangle(cornerRadius: 16))
                //                    }.padding(.top, 8).padding(.horizontal, 20)
                //
                VStack(spacing:6){
                    HStack{
                        Text("Streak")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                        Spacer()
                    }
                    //                    if streak != 0 {
                    
                    ZStack{
                        VStack(alignment: .leading){
                            HStack{
                                Text("Poop Streak!")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 30, fontColor: .cLightBrown)
                                Spacer()
                            }
                            Spacer()
                        }.padding(.top, 12)
                        VStack{
                            Spacer()
                            HStack(alignment: .bottom){
                                VStack(alignment: .leading){
                                    Text("Keep it going!")
                                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                                    
                                    ButtonPoop(text: "Drop a Poop")
                                        .onTapGesture {
                                            streak += 1
                                        }
                                }
                                
                                Spacer()
                                
                            }
                           
                            
                            
                        }.padding(.bottom, 16)
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Text("\(streak)")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 100, fontColor: .cLightBrown)
                            }
                            
                        }
                        .padding(.bottom, -12)

                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, maxHeight: 140)
                    .background(
                        Image("ImagePlaceHolder8")
                            .resizable()
                            .scaledToFill()
                    )
                   
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    //                    }else{
                    //                        VStack{
                    //                            HStack(alignment: .bottom){
                    //                                Text("You lost a")
                    //                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                    //                                Text("342")
                    //                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 38, fontColor: .cLightBrown)
                    //                                    .padding(.vertical, -5)
                    //                                Text("days streak!")
                    //                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .cLightBrown)
                    //                            }
                    //                            .padding(.top, -24)
                    //                            .frame(maxWidth: .infinity, maxHeight: 30)
                    //
                    //
                    //                            Spacer()
                    //                            HStack(alignment: .bottom){
                    //                                Text("You forgot to Poop?")
                    //                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown)
                    //                                Spacer()
                    //                                ButtonPoop(text: "Restart")
                    //                                    .onTapGesture {
                    //                                        streak += 1
                    //                                    }
                    //                            }.padding(.top, 12)
                    //                        }.padding(.horizontal, 16)
                    //                            .background(
                    //                                Image("StreakBreack")
                    //                                    .resizable()
                    //                                    .scaledToFill()
                    //                                    .frame(maxWidth: .infinity, maxHeight: 170)
                    //                                    .clipShape(RoundedRectangle(cornerRadius: 16)))
                    //                    }
                    
                    
                }.padding(.horizontal, 20)
                
                
                SliderNextToYou(homeModel: homeModel)
                
                VStack(spacing: 6){
                    HStack{
                        Text("Friends Reviews")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                        Spacer()
                    }.padding(.horizontal, 20)
                    ReviewsScroller(names: names)
                }.padding(.bottom, 12)
                
                
            }
            
            
        }.background(.cLightBrown)
    }
}
