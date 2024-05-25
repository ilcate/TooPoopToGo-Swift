//
//  InformationAnnotationView.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct InformationOfSelectionView: View {
    @State var bathroom : BathroomApi
    @EnvironmentObject var api: ApiManager
    
    var body: some View {
        VStack{
            if bathroom.name != "" {
                NavigationLink(destination: DetailBathroom(bathroom: bathroom)){
                    //TODO: refactora questo ci sono legit 3 cose uguali, coglione!
                    HStack(spacing: 0) {
                        if let photos = bathroom.photos, !photos.isEmpty, let photo = photos.first?.photo, let url = URL(string: "\(api.url)\(photo)") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 96)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 8)
                            } placeholder: {
                                Image("noPhoto")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88, height: 96)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 8)
                            }
                        } else {
                            Image("noPhoto")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 88, height: 96)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 8)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(bathroom.name!)
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
                            
                            HStack {
                                // ogni bagno avrà un array di tag e io filtro i primi due
                                SmallTag(text: "Trending")
                                SmallTag(text: "Cleanest")
                            }
                        }
                        .padding(.trailing, 10)
                        .padding(.vertical, 8)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, maxHeight: 110)
                    
                    
                }
            }
        }
        
    }
    
}





