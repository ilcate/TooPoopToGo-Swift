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
    @State private var image : String?
    @State private var sizeBox : CGFloat?
    
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
                            HStack(spacing: 4) {
                                ForEach(images, id: \.self) { imageName in
                                    Circle()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(imageName == image ? Color.accent : Color.accent.opacity(0.1))
                                    //Image(imageName == image ? "StarFill" : "StarEmpty")
                                        //.resizable()
                                        
                                }
                            }
                            .padding(.vertical, 2)
                            .padding(.horizontal, 3.5)
                            .background(.white)
                            .clipShape(Capsule())
                            
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
                    Text("Milano, Milano, Italia")
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 18, fontColor: .accent)
                    Spacer()
                    HStack(spacing: 2){
                        Image("Pin")
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
            VStack{
                FilterBottom(mapViewModel: mapViewModel)
            }.padding(.bottom, -10).padding(.top, -14)
            
            VStack{
                Spacer()
                HStack{
                    Text("‘A great experience’")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 20, fontColor: .accent)
                    Spacer()
                    HStack(spacing: 0){
                        Image("StarFill")
                            .resizable()
                            .foregroundStyle(.accent)
                            .frame(width: 14, height: 14)
                        Text("4.99")
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
            
            
            Spacer()
            
        }
        
        
        
        
    }
    
}
