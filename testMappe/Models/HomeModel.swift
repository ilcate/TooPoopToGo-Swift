
import Foundation
import CoreLocation


class HomeModel : ObservableObject{
    @Published var nextToYou : [BathroomApi] = []
    @Published var centerLat : Double = 0 //Double((locationManager.location?.coordinate.latitude) ?? 0)
    @Published var centerLong : Double = 0 // Double((locationManager.location?.coordinate.longitude) ?? 0)
    
    
    func foundNextToYou(api: ApiManager){
        let locationManager = CLLocationManager()
        centerLat = Double((locationManager.location?.coordinate.latitude) ?? 0)
        centerLong = Double((locationManager.location?.coordinate.longitude) ?? 0)
        
        api.getBathroomsNearToYou(lat: self.centerLat, long: self.centerLong, distance: 4) { result in
                switch result {
                case .success(let array):
                    if !array.isEmpty {
                        self.nextToYou.removeAll()
                        array.forEach { e in
                            self.nextToYou.append(e)
                        }
                    }
                case .failure(let error):
                    print("Error fetching bathrooms: \(error)")
                }
        }
    }
}
