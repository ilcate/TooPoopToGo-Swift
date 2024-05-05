//
//  InformationAnnotationView.swift
//  testMappe
//
//  Created by Christian Catenacci on 30/04/24.
//

import SwiftUI

struct InformationOfSelectionView: View {
    @ObservedObject var mapViewModel: MapModel
    
    
    var body: some View {
        
        VStack{
            if let selected = mapViewModel.selected {
                HStack(spacing: 0){
                    Image(uiImage: selected.image.count > 0 ? selected.image[0]! : UIImage(named: "ImagePlaceHolder")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 88, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                    
                    
                    VStack(alignment: .leading){
                        Text(selected.name)
                            .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 20, fontColor: .accentColor)
                        Text("alberto")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                    }.padding(10)
                    Spacer()
                }
                /*.onAppear{
                    mapViewModel.randomImage = selected.image.randomElement()!
                }*/
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: .infinity)
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

