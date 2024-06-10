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
    @State var arrOfTags : [Bool] = [false, false, false, false, false, false, false, false]
    @State var ovRating = ""
    @StateObject var mapViewModel: MapModel
    
    var body: some View {
        VStack {
            if !bathroom.name!.isEmpty {
                NavigationLink(destination: DetailBathroom(mapViewModel:mapViewModel, bathroom: bathroom )) {
                    HStack(spacing: 0) {
                        if !loading{
                            if let photos = bathroom.photos, !photos.isEmpty, let photo = photos.first?.photo, let url = photo.hasPrefix("http://") ? URL(string: photo.replacingOccurrences(of: "http://", with: "https://")) : URL(string: "\(api.url)\(photo)") {
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

                        VStack(alignment: .leading, spacing: -4) {
                            HStack {
                                HStack{
                                    Text(bathroom.name!.capitalized)
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 24, fontColor: .accentColor)
                                    Spacer()
                                }
    
                                Spacer()
                                Image("StarFill")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, -6)
                                Text(ovRating)
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accentColor)
                            }
                            Text(getStreet(bathroom.address ?? "" ))
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accentColor)
                            Spacer()
                            DisplayTagsB(arrBool: arrOfTags, limit: 2)
                            
                        }
                        .padding(.trailing, 10)
                        .padding(.bottom, 7).padding(.top, 3)
                        .task{
                            arrOfTags = getBathroomTags(bathroom: bathroom)
                            api.getRevStats(idB: bathroom.id!) { res in
                                switch res{
                                case .success(let stats):
                                    ovRating = stats.overall_rating
                                case .failure(let error):
                                    print("Failed to fetch review stats: \(error)")
                                }
                            
                            }
                        }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, maxHeight: 110)
                }
            }
        }.onChange(of: bathroom) {
            loading = true
            DispatchQueue.main.async {
                arrOfTags = getBathroomTags(bathroom: bathroom)
                api.getRevStats(idB: bathroom.id!) { res in
                    switch res{
                    case .success(let stats):
                        ovRating = stats.overall_rating
                    case .failure(let error):
                        print("Failed to fetch review stats: \(error)")
                    }
                
                }
                loading = false
            }
        }
    }
}

    





