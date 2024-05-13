//
//  DetailBathroom.swift
//  testMappe
//
//  Created by Christian Catenacci on 06/05/24.
//

import SwiftUI

struct DetailBathroom: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var mapViewModel: MapModel
    @State private var images = ["ImagePlaceHolder", "ImagePlaceHolder2", "ImagePlaceHolder3", "ImagePlaceHolder4", "ImagePlaceHolder5"]
    @State private var names = ["MistroFino", "Pisellone", "PerAssurdo", "Filippino"]
    @State private var image : String?
    @State private var sizeBox : CGFloat?
    @State private var openSheetNavigate =  false
    @State private var openSheetAddReview =  false
    
    var body: some View {
        VStack{
            ZStack{
                ScrollView(.horizontal){
                    HStack(spacing: 0){
                        ForEach(images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 320)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                .clipped()
                            
                        }
                    }
                    .scrollTargetLayout()
                }
                .onAppear{
                    image = images[0]
                }
                .scrollPosition(id: $image, anchor: .center)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea(.all, edges: .top)
                
                VStack{
                    HStack{
                        Image("BackArrow")
                            .uiButtonStyle(backgroundColor: .white)
                            .onTapGesture {
                                dismiss()
                            }
                        Spacer()
                        
                        Image("Share")
                            .uiButtonStyle(backgroundColor: .white)
                            .onTapGesture {
                                dismiss()
                            }
                        Image("Liked")
                            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                            .uiButtonStyle(backgroundColor: .white)
                            .onTapGesture {
                                dismiss()
                            }
                    }.padding(.top, 28)
                    Spacer()
                }.padding(.horizontal, 20)
                
                VStack {
                    Spacer()
                    withAnimation(.smooth) {
                        
                        HStack{
                            HStack(spacing: 6) {
                                ForEach(images, id: \.self) { imageName in
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(imageName == image ? Material.ultraThick : Material.ultraThin)
                                    
                                }
                            }
                            .padding(.vertical, 2)
                            .padding(.horizontal, 3.5)
                            
                            Spacer()
                            
                            
                        }
                    }
                }.padding(.bottom, 40)
                    .padding(.leading, 20)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 280)
            .navigationBarBackButtonHidden(true)
            
            VStack(spacing: 0){
                HStack{
                    Text("Bar Vecchia Sciesa")
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 26, fontColor: .accent)
                    Spacer()
                    Text("20 min")
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 20, fontColor: .accent)
                }
                HStack{
                    Text("Milano, MI, Italia")
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                    Spacer()
                    HStack(spacing: 2){
                        Image("PinHole")
                            .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                            .resizable()
                            .frame(width: 12, height: 16)
                            .foregroundStyle(.accent)
                        Text("500m")
                            .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                    }
                    
                }
                
            }
            .padding(.horizontal, 20).padding(.top, -4)
                ScrollView(.horizontal){
                    HStack{
                        SmallTag(text: "Trending")
                        SmallTag(text: "Cleanest")
                        SmallTag(text: "Accessible")
                        SmallTag(text: "Newest")
                    }.padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
                .padding(.bottom, 8).padding(.top, -4)
            
            
            VStack{
                Spacer()
                HStack{
                    Text("“A great experience”")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 20, fontColor: .accent)
                    Spacer()
                    HStack(spacing: 2){
                        Image("StarFill")
                            .resizable()
                            .foregroundStyle(.accent)
                            .frame(width: 14, height: 14)
                        Text("4.9")
                            .normalTextStyle(fontName: "Manrope-Regular", fontSize: 18, fontColor: .accent)
                        
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 30)
                .padding(.horizontal, 12)
                Rectangle()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                    .foregroundStyle(.cUltraLightGray)
                HStack {
                    VStack(spacing:1){
                        Text("Cleanliness")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                        HStack(spacing: 0.5){
                            ForEach(0..<5) { index in
                                Image("StarFill")
                                    .resizable()
                                    .foregroundStyle(.accent)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 30)
                    Rectangle()
                        .frame(maxWidth: 2, maxHeight: .infinity)
                        .foregroundStyle(.cUltraLightGray)
                        .ignoresSafeArea(.all)
                    VStack(spacing:1){
                        Text("Comfort")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                        HStack(spacing: 0.4){
                            ForEach(0..<5) { index in
                                Image("StarFill")
                                    .resizable()
                                    .foregroundStyle(.accent)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 30)
                    Rectangle()
                        .frame(maxWidth: 2, maxHeight: .infinity)
                        .foregroundStyle(.cUltraLightGray)
                        .ignoresSafeArea(.all)
                    VStack(spacing:1){
                        Text("Accessibility")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                        HStack(spacing: 0){
                            ForEach(0..<5) { index in
                                Image("StarFill")
                                    .resizable()
                                    .foregroundStyle(.accent)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        
                    }.frame(maxWidth: .infinity, maxHeight: 30)
                }
                .frame(maxWidth: .infinity, maxHeight: 55)
                .padding(.top, -10)
                .padding(.horizontal, 12)
                .ignoresSafeArea(.all)
                
                
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 105)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.cUltraLightGray, lineWidth: 2)
            )
            .padding(.horizontal, 20).padding(.top, -4)
            VStack(spacing: 0){
                Rectangle()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 2)
                    .foregroundStyle(.cUltraLightGray)
                VStack{
                    HStack{
                        Text("Location Reviews")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accent)
                        Spacer()
                        HStack(spacing: 1){
                            Image("Close")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(45))
                            Text("Add")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .white)
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(.cGreen)
                        .clipShape(Capsule())
                        .onTapGesture {
                            openSheetAddReview = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 2)
                    
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
                                .frame(maxWidth: .infinity, maxHeight: 144)
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
                    .scrollPosition(id: $image, anchor: .leading)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    .padding(.vertical, -20)
                    
                    
                    Spacer()
                    
                    VStack {
                        
                        Text("Bring me there!")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                            .frame(maxWidth: .infinity, maxHeight: 46)
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                            .padding(.horizontal, 20)
                            .padding(.top, -8)
                            .onTapGesture {
                                openSheetNavigate = true
                            }
                    }
                    Spacer()
                    
                }
            }
            
            
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(.cLightBrown)
            .padding(.top, 6)
            
            
            
            Spacer()
            
            
        }.ignoresSafeArea(.all, edges: .bottom)
            .sheet(isPresented: $openSheetNavigate, onDismiss: {
                openSheetNavigate = false
            }) {
                ZStack {
                    Color.cLightBrown.ignoresSafeArea(.all)
                    SheetNavigate()
                        .presentationDetents([.fraction(0.30)])
                        .presentationCornerRadius(18)
                }
                
            }
            .sheet(isPresented: $openSheetAddReview, onDismiss: {
                openSheetAddReview = false
            }) {
                ZStack {
                    Color.cLightBrown.ignoresSafeArea(.all)
                    SheetAddReview()
                        .presentationDetents([.fraction(0.46)])
                        .presentationCornerRadius(18)
                }
                
            }
        
        
    }
    
}


struct SheetNavigate: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Take me there!")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                Spacer()
                Image("Close")
                    .resizable()
                    .foregroundStyle(.accent)
                    .padding(4)
                    .background(.white)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .onTapGesture {
                        dismiss()
                    }
            }.padding(.horizontal, 20)
            
            
            Text("Google maps")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                .frame(maxWidth: .infinity, maxHeight: 46)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 1000))
                .padding(.horizontal, 20)
                .onTapGesture {
                    if let url = URL(string: "https://www.google.com/maps/?q=\(45.4654219),\(9.1859243)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL( string: "https://apps.apple.com/it/app/google-maps-gps-e-ristoranti/id585027354")!, options: [:], completionHandler: nil)
                    }
                }
            
            Text("Apple maps")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                .frame(maxWidth: .infinity, maxHeight: 46)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 1000))
                .padding(.horizontal, 20)
                .onTapGesture {
                    if let url = URL(string: "http://maps.apple.com/?daddr=\(45.4654219),\(9.1859243)&dirflg=d&t=m"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id915056765")!, options: [:], completionHandler: nil)
                    }
                }
            
            Text("Waze")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                .frame(maxWidth: .infinity, maxHeight: 46)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 1000))
                .padding(.horizontal, 20)
                .onTapGesture {
                    if let url = URL(string: "waze://?ll=\(45.4654219),\(9.1859243)&navigate=yes"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id323229106")!, options: [:], completionHandler: nil)
                    }
                }
            
        }
        
    }
}



struct SheetAddReview: View {
    @Environment(\.dismiss) var dismiss
    var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    
    @State private var descNewAnnotation = ""
    
    var body: some View {
        VStack{
            HStack{
                Text("Describe how you felt")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                Spacer()
                Image("Close")
                    .resizable()
                    .foregroundStyle(.accent)
                    .padding(4)
                    .background(.white)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .onTapGesture {
                        dismiss()
                    }
            }.padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                Text("Ratings")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                    .padding(.bottom, -2)
                VStack {
                    RatingsStars(RatingName: "Cleanliness", RatingStars: cleanStar)
                    RatingsStars(RatingName: "Comfort", RatingStars: comfortStar)
                    RatingsStars(RatingName: "Mood", RatingStars: moodStar)
                    
                }
                .padding(.vertical, 9)
                .padding(.horizontal, 16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }.padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                Text("Leave a comment")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                    .padding(.bottom, -2)
                TextField("Insert here", text: $descNewAnnotation)
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.white)
                    .clipShape(.capsule)
            }.padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            Text("Send Review!")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                .frame(maxWidth: .infinity, maxHeight: 46)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 1000))
                .padding(.horizontal, 20)
                .onTapGesture {
                    dismiss()
                }
            
        }
        
    }
}
