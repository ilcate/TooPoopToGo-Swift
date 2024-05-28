//
//  InformationAnnotationView.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct InformationOfSelectionView: View {
    var bathroom: BathroomApi
    @EnvironmentObject var api: ApiManager
    @State var loading = false
    
    var body: some View {
        VStack {
            if  !bathroom.name!.isEmpty {
                NavigationLink(destination: DetailBathroom(bathroom: bathroom)) {
                    HStack(spacing: 0) {
                        if !loading{
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
                        }else{
                            CoverDef()
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                HStack{
                                    Text(bathroom.name!)
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 24, fontColor: .accentColor)
                                    Spacer()
                                }
                               
                                Spacer()
                                Image("StarFill")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, -4)
                                Text("4.99")
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accentColor)
                            }
                            Text(getStreet(bathroom.address ?? "" ))
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accentColor)
                            Spacer()
                            HStack {
                                SmallTag(text: String(bathroom.place_type!.capitalized))
                                SmallTag(text: "Free")
                               
                            }
                        }
                        .padding(.trailing, 10)
                        .padding(.bottom, 7).padding(.top, 3)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, maxHeight: 110)
                }
            }
        }.onChange(of: bathroom) {
            loading = true
            DispatchQueue.main.async {
                loading = false
            }
        }
    }
}

    





