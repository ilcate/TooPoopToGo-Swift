//
//  SheetNavigate.swift
//  TooPoopToGo
//
//  Created by Christian Catenacci on 26/05/24.
//

import SwiftUI


struct SheetNavigate: View {
    @Environment(\.dismiss) var dismiss
    @State var bathroom : BathroomApi
    
    var body: some View {
        
        VStack{
            UpperSheet(text: "Take me there!", pBottom: 12, pHor: 20)
            
            FullRoundedButton(text: "Google Maps")
                .onTapGesture {
                    if let url = URL(string: "https://www.google.com/maps/?q=\(String(describing: bathroom.coordinates!.coordinates![1])),\(String(describing: bathroom.coordinates!.coordinates![0]))"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL( string: "https://apps.apple.com/it/app/google-maps-gps-e-ristoranti/id585027354")!, options: [:], completionHandler: nil)
                    }
                }
            
            FullRoundedButton(text: "Apple Maps")
                .onTapGesture {
                    if let url = URL(string: "http://maps.apple.com/?daddr=\(String(describing: bathroom.coordinates!.coordinates![1])),\(String(describing: bathroom.coordinates!.coordinates![0]))&dirflg=d&t=m"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id915056765")!, options: [:], completionHandler: nil)
                    }
                }
            
            FullRoundedButton(text: "Waze")
                .onTapGesture {
                    if let url = URL(string: "waze://?ll=\(String(describing: bathroom.coordinates!.coordinates![1])),\(String(describing: bathroom.coordinates!.coordinates![0]))&navigate=yes"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id323229106")!, options: [:], completionHandler: nil)
                    }
                }
            
        }
        
    }
}




