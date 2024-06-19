import SwiftUI

struct SheetNavigate: View {
    @Environment(\.dismiss) var dismiss
    @State var bathroom: BathroomApi
    
    var body: some View {
        VStack {
            UpperSheet(text: "Take me there!", pBottom: 12, pHor: 20)
            
            NavigationButton(title: "Google Maps", urlScheme: "https://www.google.com/maps/?q=\(bathroom.coordinates!.coordinates![1]),\(bathroom.coordinates!.coordinates![0])", fallbackURL: "https://apps.apple.com/it/app/google-maps-gps-e-ristoranti/id585027354")
            
            NavigationButton(title: "Apple Maps", urlScheme: "http://maps.apple.com/?daddr=\(bathroom.coordinates!.coordinates![1]),\(bathroom.coordinates!.coordinates![0])&dirflg=d&t=m", fallbackURL: "itms-apps://itunes.apple.com/app/id915056765")
            
            NavigationButton(title: "Waze!", urlScheme: "waze://?ll=\(bathroom.coordinates!.coordinates![1]),\(bathroom.coordinates!.coordinates![0])&navigate=yes", fallbackURL: "itms-apps://itunes.apple.com/app/id323229106")
        }
    }
}

