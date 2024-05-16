//
//  Annotation.swift
//  testMappe
//
//  Created by Christian Catenacci on 05/05/24.
//

import SwiftUI

struct Annotation: View {
    @ObservedObject var mapViewModel : MapModel
    @Binding var ann : AnnotationServer
    
    var body: some View {
        VStack{
            Image(mapViewModel.filterSelected)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle((ann == mapViewModel.selected && mapViewModel.tappedAnnotation() && mapViewModel.filterSelected == "Roll") ? .white : .accent)
                .padding(.bottom, 8)
                .background(
                    Image("Pin") 
                        .renderingMode(.template)
                        .foregroundStyle(ann == mapViewModel.selected && mapViewModel.tappedAnnotation() ? .accent: .white)
                )
                .onTapGesture {
                    withAnimation(.snappy) {
                        mapViewModel.moveToDestination(cords: [ann.latitude, ann.longitude, ann.zoom], dur: 0.3)
                        mapViewModel.selected = ann
                    }
                }
            
           
            Ellipse()
                .frame(width: 16, height: 4)
                .opacity(0.3)
                .blur(radius: 0.5)
                .padding(.top, -2)
        }
        
    }
}

