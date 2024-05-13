//
//  InformationAnnotationView.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct InformationOfSelectionView: View {
    @ObservedObject var mapViewModel: MapModel
    var ranodmN = 400
    
    var body: some View {
       
        VStack{
            if let selected = mapViewModel.selected {
                NavigationLink(destination: DetailBathroom(mapViewModel:mapViewModel)){
                    HStack(spacing: 0){
                        Image(uiImage: selected.image.count > 0 ? selected.image[0]! : UIImage(named: "ImagePlaceHolder")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 88, height: 96)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.vertical, 8).padding(.horizontal, 8)
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
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, maxHeight: 110)
                }
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





