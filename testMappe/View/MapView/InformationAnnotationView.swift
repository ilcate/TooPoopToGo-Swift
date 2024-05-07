//
//  InformationAnnotationView.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct InformationOfSelectionView: View {
    @ObservedObject var mapViewModel: MapModel
    
    var ranodmN = Int.random(in: 1..<800)
    
    var body: some View {
        NavigationLink(destination: DetailBathroom()){
           VStack{
               if let selected = mapViewModel.selected {
                   HStack(spacing: 0){
                       Image(uiImage: selected.image.count > 0 ? selected.image[0]! : UIImage(named: "ImagePlaceHolder")!)
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: 88, height: 96)
                           .clipShape(RoundedRectangle(cornerRadius: 8))
                           .padding(.vertical, 8).padding(.horizontal, 10)
                       VStack(alignment: .leading, spacing: 0){
                           HStack{
                               Text(selected.name)
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
                           Text("\(ranodmN)m from you")
                               .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accentColor)
                           Spacer()
                           
                           HStack{
                               SmallTag(text: "Trending")
                               SmallTag(text: "Cleanest")
                               
                           }
                           
                       }
                       .padding(.trailing, 10).padding(.vertical, 8)
                       
                       
                   }
                   /*.onAppear{
                    mapViewModel.randomImage = selected.image.randomElement()!
                    }*/
                   .background(Color.white)
                   .clipShape(RoundedRectangle(cornerRadius: 10))
                   .frame(maxWidth: .infinity, maxHeight: 110)
               }
           }
           .padding(.bottom, mapViewModel.selected?.name != "" ? 72 : 0)
           .opacity(mapViewModel.selected?.name != "" ? 1 : 0)
           .onChange(of: mapViewModel.viewport){
               if !mapViewModel.checkCoordinates() {
                   mapViewModel.removeSelection()
               }
           }
        }
        
    }
}




struct SmallTag: View {
    var text : String
    
    var body: some View {
        HStack(spacing: 2){
            Image(text)
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundStyle(.accent)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: Color.accent)
        }
        .padding(.vertical, 4).padding(.leading, 3).padding(.trailing, 6)
        .background(.cUltraLightGray)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
}
