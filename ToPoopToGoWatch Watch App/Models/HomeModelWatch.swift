
import SwiftUI
import CoreLocation


class HomeModelWatch : ObservableObject{
    @Published var nextToYou : [BathroomApi] = []
    @Published var centerLat : Double = 0
    @Published var centerLong : Double = 0
    
    
    func foundNextToYou(api: ApiManagerWatch){
        let locationManager = CLLocationManager()
        centerLat = Double((locationManager.location?.coordinate.latitude) ?? 0)
        centerLong = Double((locationManager.location?.coordinate.longitude) ?? 0)
        
        
        api.getBathroomsNearToYou(lat: self.centerLat, long: self.centerLong, distance: 10000) { result in
                switch result {
                case .success(let array):
                    if !array.isEmpty {
                        array.forEach { element in
                            self.nextToYou.append(BathroomApi(id: element.id, photos: element.photos, name: element.name, address: element.address, coordinates: element.coordinates, place_type: element.place_type, is_for_disabled: element.is_for_disabled, is_free: element.is_free, is_for_babies: element.is_for_babies, tags: element.tags, updated_at: element.updated_at))
                        }
                       
                    }
                    
                case .failure(let error):
                    print("Error fetching bathrooms: \(error)")
                }
        }
    }
}
