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
            Image(mapViewModel.filterSelected)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle((ann == mapViewModel.selected! && mapViewModel.tappedAnnotation() && mapViewModel.filterSelected == "Roll") ? .white : .accent)
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
                        print(ann)
                    }
                    
                }
            
            
            Ellipse()
                .frame(width: 16, height: 4)
                .opacity(0.3)
                .blur(radius: 0.5)
                .padding(.top, -2)
        }
        .opacity(annotationOpacity())
    }
    
    private func annotationOpacity() -> Double {
        switch mapViewModel.filterSelected {
        case "Accessible": return ann.tags?.accessible == true ? 1 : 0
        case "Newest": return ann.tags?.newest == true ? 1 : 0
        case "ForBabies": return ann.tags?.forBabies == true ? 1 : 0
        case "Free": return ann.tags?.free == true ? 1 : 0
        case "Public": return ann.place_type?.capitalized == "Public" ? 1 : 0
        case "Restaurant": return ann.place_type?.capitalized == "Restaurant" ? 1 : 0
        case "Bar": return ann.place_type?.capitalized == "Bar" ? 1 : 0
        case "Shop" :return ann.place_type?.capitalized == "Shop" ? 1 : 0
        default: return 1
        }
    }
}

