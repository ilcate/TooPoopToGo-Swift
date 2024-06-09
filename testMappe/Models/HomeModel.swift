import SwiftUI
import Combine
import UserNotifications
import CoreLocation

class HomeModel: ObservableObject {
    @Published var nextToYou: [BathroomApi] = []
    @Published var centerLat: Double = 0
    @Published var centerLong: Double = 0
    @Published var status: String = ""
    @Published var count: Int = 0
    
    func foundNextToYou(api: ApiManager) {
        let locationManager = CLLocationManager()
        centerLat = Double((locationManager.location?.coordinate.latitude) ?? 0)
        centerLong = Double((locationManager.location?.coordinate.longitude) ?? 0)
        
        api.getBathroomsNearToYou(lat: self.centerLat, long: self.centerLong, distance: 1) { result in
            switch result {
            case .success(let array):
                if !array.isEmpty {
                    self.nextToYou.removeAll()
                    array.forEach { element in
                        self.nextToYou.append(BathroomApi(id: element.id, photos: element.photos, name: element.name, address: element.address, coordinates: element.coordinates, place_type: element.place_type, is_for_disabled: element.is_for_disabled, is_free: element.is_free, is_for_babies: element.is_for_babies, tags: element.tags, updated_at: element.updated_at))
                    }
                }
            case .failure(let error):
                print("Error fetching bathrooms: \(error)")
            }
        }
    }
    
    func fetchPS(api: ApiManager) {
        api.getPoopStreak() { response in
            switch response {
            case .success(let poopStreak):
                self.status = poopStreak.streak_status
                self.count = poopStreak.poop_count
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func updatePS(api: ApiManager) {
        api.updatePoopStreak() { response in
            switch response {
            case .success(let poopStreak):
                self.status = poopStreak.streak_status
                self.count = poopStreak.poop_count
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func scheduleNotificationForNextDay() {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Your PoopStreak is ready"
                content.body = "Remember to release the MONSTER!🤰 "
                content.sound = UNNotificationSound.default
                
                let now = Date()
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                dateComponents.day! += 1
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error adding notification: \(error)")
                    }
                }
            } else {
                print("Notification permissions not granted.")
            }
        }
    }
}


