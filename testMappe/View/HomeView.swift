//
//  HomeView.swift
//  testMappe
//
//  Created by Christian Catenacci on 26/04/24.
//

//TODO: refactorare tutti i testi allineati a sinistra
//TODO: spostare tutta la logica dentro il model

import SwiftUI

struct HomeView: View {
    @State private var names = ["MistroFino", "Pisellone", "PerAssurdo", "Filippino"]

    
    var body: some View {
        VStack{
            HeadersViewPages(PageName: "Home")
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
                            .clipShape(Capsule())
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
                            }.padding(.leading, 16).padding(.top, 2)
                            Spacer()
                            Image("ImagePlaceHolder7")
                                .resizable()
                                .frame(width: 60 , height: 60)
                                .padding(.trailing, 16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 86)
                        .background(.cLightBrown50)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }.padding(.top, 8).padding(.horizontal, 20)
                    
                    VStack{
                        HStack{
                            Text("Streak")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            Spacer()
                        }.padding(.bottom, 14)
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Poop Streak!")
                                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 30, fontColor: .cLightBrown)
                                        .padding(.bottom, -20).padding(.top, -8)
                                    HStack{
                                        VStack(alignment: .leading){
                                            Spacer()
                                            Text("Keep it going!")
                                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .cLightBrown)
                                            Spacer()
                                            HStack(spacing: 2){
                                                Image("CleanestCircle")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(width: 26, height: 26)
                                                Text("Drop a Poop")
                                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .accent)
                                                
                                            }.padding(.leading, 8).padding(.trailing, 8).padding(.vertical, 4)
                                                .background(.ultraThickMaterial)
                                                .clipShape(Capsule())
                                        }
                                        Spacer()
                                        
                                        Text("99")
                                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 100, fontColor: .cLightBrown)
                                        
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 80)
                                    
                                }
                                
                                
                            }.padding(.horizontal, 16)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(
                            Image("ImagePlaceHolder8")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        )
                        
                    }.padding(.horizontal, 20)
                    
                    VStack(spacing: 6){
                        HStack{
                            Text("Next to you")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            Spacer()
                        }.padding(.horizontal, 20)
                        ScrollView(.horizontal){
                            HStack(spacing: 0){
                                ForEach(names, id: \.self) { name in
                                   
                                    
                                    VStack{
                                        HStack(spacing: 0){
                                            Image("ImagePlaceHolder")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 88, height: 96)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .padding(.vertical, 8).padding(.horizontal, 8)
                                            VStack(alignment: .leading, spacing: 0){
                                                HStack{
                                                    Text(name)
                                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 24, fontColor: .accentColor)
                                                    Spacer()
                                                    Image("StarFill")
                                                        .resizable()
                                                        .frame(width: 14, height: 14)
                                                        .foregroundStyle(.accent)
                                                        .padding(.trailing, -4)
                                                    Text("4.99")
                                                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accentColor)
                                                }
                                                Text("400m from you")
                                                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accentColor)
                                                Spacer()
                                                
                                                HStack{
                                                    SmallTag(text: "Trending")
                                                    SmallTag(text: "Cleanest")
                                                    
                                                }
                                                
                                            }
                                            .padding(.trailing, 10).padding(.vertical, 8)
                                            .frame(maxWidth: .infinity, maxHeight: 110)
                                            
                                        }
                                    }
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                                    .padding(.trailing, 10)
                                    
                    
                                    
                                }
                            }
                            .padding(.trailing, -10)
                            .scrollTargetLayout()
                        }
                        .contentMargins(20, for: .scrollContent)
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.viewAligned)
                        .padding(.vertical, -20)
                    }.padding(.top, 18)
                    
                    VStack(spacing: 6){
                        HStack{
                            Text("Friends Reviews")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                            Spacer()
                        }.padding(.horizontal, 20)
                        ScrollView(.horizontal){
                            HStack(spacing: 0){
                                ForEach(names, id: \.self) { name in
                                    VStack{
                                        HStack{
                                            Image("ImagePlaceHolder3")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                            VStack(alignment:.leading, spacing: 1){
                                                Text(name)
                                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                                                Text("3 hours ago")
                                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 14, fontColor: .accent)
                                                
                                            }
                                            Spacer()
                                            
                                        }.padding(.horizontal, 16)
                                        Text("Just had her biggest shit ever and did the review at 14 bathrooms in 3 days! porco dio devo aggiungere testo")
                                            .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                                            .padding(.horizontal, 10)
                                        
                                    }
                                    .padding(.vertical, 8)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                                    .padding(.trailing, 10)
                                    
                                }
                            }
                            .padding(.trailing, -10)
                            .scrollTargetLayout()
                        }
                        .contentMargins(20, for: .scrollContent)
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.viewAligned)
                        .padding(.vertical, -20)
                    }.padding(.bottom, 12)
                    
                    
                   
                   
                    
                    
                    
                    
                }
            }
            
            
        }.background(.cLightBrown)
    }
}
