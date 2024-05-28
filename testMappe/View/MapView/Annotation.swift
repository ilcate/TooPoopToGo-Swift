//
//  Annotation.swift
//  testMappe
//
//  Created by Christian Catenacci on 05/05/24.
//

import SwiftUI

struct Annotation: View {
    @ObservedObject var mapViewModel : MapModel
    @Binding var ann : BathroomApi
    
    var body: some View {
        VStack{
            Image(imageToDisplay())
                .resizable()
                .renderingMode(.original)
                .frame(width: 20, height: 20)
                .padding(.bottom, 8)
                .background(
                    Image("Pin")
                        .renderingMode(.template)
                        .foregroundStyle(ann == mapViewModel.selected && mapViewModel.tappedAnnotation() ? .accent: .white)
                )
                .onTapGesture {
                    withAnimation(.snappy) {
                        mapViewModel.moveToDestination(cords: [CGFloat((ann.coordinates?.coordinates![1])!), CGFloat((ann.coordinates?.coordinates![0])!), 15], dur: 0.3)
                        mapViewModel.selected = ann
                    }
                }
            Ellipse()
                .frame(width: 16, height: 4)
                .opacity(0.3)
                .blur(radius: 0.5)
                .padding(.top, -2)
        }
//        .opacity(annotationOpacity())
    }
    func imageToDisplay() -> String{
        switch mapViewModel.filterSelected {
        case "Accessible": return ann.tags?.accessible == true ?  "Accessible" :  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Newest": return ann.tags?.newest == true ? "Newest" :  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Babies": return ann.tags?.forBabies == true ? "Babies": ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Free": return ann.tags?.free == true ? "Free" :  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Public": return ann.place_type?.capitalized == "Public" ? "Public" :  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Restaurant": return ann.place_type?.capitalized == "Restaurant" ? "Restaurant":  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Bar": return ann.place_type?.capitalized == "Bar" ? "Bar" :  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Shop" :return ann.place_type?.capitalized == "Shop" ? "Shop" :  ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        case "Roll" :return ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() ? "RollWhite" :  "Roll"
        default: return "Roll"
        }
    }
}

