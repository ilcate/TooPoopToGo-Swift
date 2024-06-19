//import SwiftUI
//import CoreLocation
//import WatchKit
//
//struct SheetNavigate: View {
//    @Environment(\.dismiss) var dismiss
//    @State var bathroom: BathroomApi
//    
//    var body: some View {
//        VStack {
//            Text("Google Maps")
//                .onTapGesture {
//                    openURL("https://www.google.com/maps/?q=\(String(describing: bathroom.coordinates!.coordinates![1])),\(String(describing: bathroom.coordinates!.coordinates![0]))")
//                }
//            
//            Text("Apple maps")
//                .onTapGesture {
//                    openURL("http://maps.apple.com/?daddr=\(String(describing: bathroom.coordinates!.coordinates![1])),\(String(describing: bathroom.coordinates!.coordinates![0]))&dirflg=d&t=m")
//                }
//            
//            Text("Waze!")
//                .onTapGesture {
//                    openURL("waze://?ll=\(String(describing: bathroom.coordinates!.coordinates![1])),\(String(describing: bathroom.coordinates!.coordinates![0]))&navigate=yes")
//                }
//            
//            Spacer()
//        }
//    }
//    
//    func openURL(_ urlString: String) {
//        if let url = URL(string: urlString) {
//            WKExtension.shared().openSystemURL(url)
//        } else if let fallbackURL = URL(string: "itms-apps://itunes.apple.com") {
//            WKExtension.shared().openSystemURL(fallbackURL)
//        }
//    }
//}
