//
//  InformationAnnotationView.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct InformationOfSelectionView: View {
    @State var bathroom: BathroomApi
    @EnvironmentObject var api: ApiManager

    var body: some View {
        VStack {
            if let name = bathroom.name, !name.isEmpty {
                NavigationLink(destination: DetailBathroom(bathroom: bathroom)) {
                    HStack(spacing: 0) {
                        if let photos = bathroom.photos, !photos.isEmpty, let photo = photos.first?.photo, let url = URL(string: "\(api.url)\(photo)") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .resizableImageStyleSmall()
                            } placeholder: {
                                CoverDef()
                            }
                        } else {
                            CoverDef()
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack{
                                    Text(name)
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 24, fontColor: .accentColor)
                                    Spacer()
                                }
                               
                                Spacer()
                                Image("StarFill")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.accentColor) // Usa foregroundColor invece di foregroundStyle
                                    .padding(.trailing, -4)
                                Text("4.99")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accentColor)
                            }
                            Text("400m from you")
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accentColor)
                            Spacer()
                            HStack {
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

    





