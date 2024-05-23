import Foundation
import SwiftUI
import PhotosUI
import CoreLocation
import Alamofire
@_spi(Experimental) import MapboxMaps



final class MapModel: ObservableObject{
    @Published var allPoints : [BathroomApi] = []
    @Published var viewport: Viewport = .followPuck(zoom: 13).padding(.all, 20) //gestisce la cam
    @Published var selected: BathroomApi? = BathroomApi(id: "", name: "", address: "", coordinates: Coordinates(), place_type: "", is_for_disabled: false, is_free: false, is_for_babies: false) //da la possibilità di aggiungere nuove annotation
    @Published var canMove = true//altra gestione della cam
    @Published var customMinZoom = 2.0//altra gestione della cam
    @Published var centerLat = 0.0//altra gestione della cam
    @Published var centerLong = 0.0//altra gestione della cam
    @Published var neBound : CLLocationCoordinate2D?
    @Published var currentZoom = 0.0//altra gestione della cam
    @Published var search = false
    @Published var searchingInput = ""
    @Published var filterSelected = "Roll"
    @Published var newLocationAdded = false
    @Published var openSheetFilters = false
    @Published var photosPikerItems: [PhotosPickerItem] = []
    @Published var nameNewAnnotation: String = ""
    @Published var openSheetUploadImage = false
    @Published var isLoading = false
    @Published var descNewAnnotation: String = ""
    @Published var imagesNewAnnotation : [UIImage] = []
    @Published var optionsDropDown = ["Public", "Bar", "Restaurant", "Shop"]
    @Published var restrictionsArray = [false, false, false]
    private var cameraChangeTimer: Timer?
    
    
    
    
    func moveToDestination(cords: [CGFloat], dur : CGFloat){
        let animationDuration = calcDur(cords: cords)
        
        withViewportAnimation(.easeOut(duration: animationDuration)) {
            viewport = .camera(center: CLLocationCoordinate2D(latitude: cords[0], longitude: cords[1]), zoom: cords[2])
        }
       
    }
    
    func calcDur(cords: [CGFloat]) -> CGFloat {
        guard let currentLatitude = viewport.camera?.center?.latitude,
              let currentLongitude = viewport.camera?.center?.longitude,
              let currentZoom = viewport.camera?.zoom else {
            return 0.8
        }
        
        let distanceLat = abs(currentLatitude - Double(cords[0]))
        let distanceLong = abs(currentLongitude - Double(cords[1]))
        let distanceZoom = abs(currentZoom - Double(cords[2]))
        
        let total = distanceLat + distanceLong + distanceZoom * 4
        
        if total < 10{
            return 0.3
        }else if total >= 10 && total < 50{
            return 0.5
        }else{
            return total/100+0.3
        }
        
    }
    
    func resetAndFollow(z: CGFloat){
        withViewportAnimation(.easeOut(duration:  0.5)) {
            viewport = Viewport.followPuck(zoom: z)
        }
    }
    
    func canMoveCheck(duration: TimeInterval){
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.canMove.toggle()
            if self.canMove != true {
                self.customMinZoom = 18
            }else{
                self.customMinZoom = 2
            }
        }
    }
    
    func checkDestination(istTab: TabBarSelection){
        if !istTab.destination.isEmpty{
            moveToDestination(cords: [istTab.destination[0], istTab.destination[1], istTab.destination[2]], dur: 0.6)
            istTab.destination = []
        }
    }
    
    func removeSelection(){
        selected = BathroomApi(id: "", name: "", address: "", coordinates: Coordinates(), place_type: "", is_for_disabled: false, is_free: false, is_for_babies: false)
    }
    
    func getCameraCenter(CameraChanged: CameraChanged){
        centerLat = CameraChanged.cameraState.center.latitude
        centerLong = CameraChanged.cameraState.center.longitude
    }
    
    func sendPointToServer(name: String, type: String, image: [UIImage], restrictions: [Bool], api : ApiManager){
        
        api.createLocation(name: name, type: type, images: image, isForDisabled: restrictions[0], isFree: restrictions[2], isForBabies: restrictions[1],long: centerLong, lat: centerLat, userToken: api.userToken)
//            allPoints.append(BathroomApi(id: "" ,image: image, latitude: centerLat, longitude: centerLong, zoom: 17, name: name))
//        canMove = true
//        customMinZoom = 2
//        newLocationAdded = true
        
   
    }
    
    
    func addAnnotationServer(element : BathroomApi){
        allPoints.append(BathroomApi(id: element.id, photos: element.photos, name: element.name, address: element.address, coordinates: element.coordinates, place_type: element.place_type, is_for_disabled: element.is_for_disabled, is_free: element.is_free, is_for_babies: element.is_for_babies))
    }
    
    func tappedAnnotation() -> Bool{
        if selected!.name != "" {
            if checkCoordinates() {
                if canMove  == true {
                    return true
                }
            }
        }
        return false
    }
    
    func checkCoordinates() -> Bool{
        if viewport.camera?.center?.latitude == selected!.coordinates?.coordinates![1] {
            if viewport.camera?.center?.longitude == selected!.coordinates?.coordinates![0] {
                return true
            }
        }
        
        return false
        
    }
    
    func searchAndAdd(api : ApiManager){
        let headers = HTTPHeaders(["Authorization": "token \(api.userToken)"])
            api.getBathrooms(lat: self.centerLat, long: self.centerLong, distance: (7800 / (self.currentZoom * 2)), headers: headers) { result in
                switch result {
                case .success(let array):
                    if !array.isEmpty {
                        for element in array {
                            if !self.allPoints.contains(where: { $0.id == element.id }) {
                                self.addAnnotationServer(element: element)
                            }
                        }
                    }
                    self.isLoading = false
                case .failure(let error):
                    print("Error fetching bathrooms: \(error)")
                    self.isLoading = false
                }
            
        }
    }
    
    func startCameraChangeTimer(api : ApiManager) {
            cameraChangeTimer?.invalidate()
            cameraChangeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                self?.isLoading = true
                self?.searchAndAdd(api: api)
                print(self!.allPoints)
               
            }
           
        }
    
    
}


