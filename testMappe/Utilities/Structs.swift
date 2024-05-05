//
//  Structs.swift
//  testMappe
//
//  Created by Christian Catenacci on 12/04/24.
//

import Foundation
import SwiftUI
import CoreLocation
@_spi(Experimental) import MapboxMaps

struct AnnotationServer: Identifiable, Equatable {
    var id = UUID()
    var image = [UIImage(named: "ImagePlaceHolder")]
    var text: String
    var latitude: CGFloat
    var longitude: CGFloat
    var zoom: CGFloat
    var name: String
    
    static func ==(lhs: AnnotationServer, rhs: AnnotationServer) -> Bool {
        return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.zoom == rhs.zoom &&
        lhs.name == rhs.name
    }
}

struct Filters: Identifiable{
    var id = UUID()
    var image: UIImage
    var name: String
    var selected = false 
    
}


struct Item: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct Stars: Identifiable{
    var id = UUID()
    var selected = false
}
