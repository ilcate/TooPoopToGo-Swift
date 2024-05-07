//
//  DetailBathroom.swift
//  testMappe
//
//  Created by Christian Catenacci on 06/05/24.
//

import SwiftUI

struct DetailBathroom: View {
    @Environment(\.dismiss) var dismiss
    @State private var images = ["ImagePlaceHolder", "ImagePlaceHolder2", "ImagePlaceHolder3", "ImagePlaceHolder4", "ImagePlaceHolder5"]
    
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
                            
                                //.frame(width: 410, height: 320)
                                //.frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 320)
                        }
                        /*Image("ImagePlaceHolder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 320)
                        Image("ImagePlaceHolder2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 320)
                        Image("ImagePlaceHolder3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 320)*/
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
               .ignoresSafeArea(.all, edges: .top)
                /*ScrollView(.horizontal){
                    HStack{
                        Image("ImagePlaceHolder")
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 280)
                            //.frame(maxWidth: .infinity, maxHeight: 280)

                        

                            
                    }
                    .frame(maxWidth: .infinity, maxHeight: 280)
                    //.scrollTargetLayout()
                    .ignoresSafeArea(.all, edges: [.top])
                }
                //.scrollTargetBehavior(.paging)
                .ignoresSafeArea(.all, edges: [.top])*/
        
               
                
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
           
           
            
            Spacer()
        }
        
        
  
        
    
}

}
