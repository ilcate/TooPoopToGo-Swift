import Foundation
import SwiftUI
import PhotosUI
import CoreLocation
import Alamofire
@_spi(Experimental) import MapboxMaps



final class MapModel: ObservableObject{
    @Published var allPoints : [BathroomApi] = []
    @Published var names : [Review] = []
    @Published var viewport: Viewport = .followPuck(zoom: 13).padding(.all, 20) //gestisce la cam
    @Published var selected: BathroomApi? = BathroomApi(id: "", name: "", address: "", coordinates: Coordinates(), place_type: "", is_for_disabled: false, is_free: false, is_for_babies: false)
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
    @Published var searchedElements : Result<[BathroomApi]?, Error>? = nil
    private var cameraChangeTimer: Timer?
    private var firstTime = true
    
    
    
    
    
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
        } else if total >= 10 && total < 50 {
            return 0.5
        } else {
            return total / 100 + 0.3
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
    
    func sendPointToServer(name: String, type: String, image: [UIImage], restrictions: [Bool], api: ApiManager, completion: @escaping (String) -> Void) {
        api.createLocation(name: name, type: type, images: image, isForDisabled: restrictions[0], isFree: restrictions[2], isForBabies: restrictions[1], long: centerLong, lat: centerLat) { result in
            switch result {
            case .success(let userInfoResponse):
                
                print("Location added successfully: \(userInfoResponse)")
                completion(userInfoResponse.id!)
            case .failure(let error):
                print("Failed to add location: \(error.localizedDescription)")
                completion("")
            }
        }
    }
    
    
    func fetchReviewStats(api: ApiManager,  bathroom: BathroomApi, completion: @escaping (GetRatingStats) -> Void) {
        DispatchQueue.main.async {
            api.getRevStats(idB: bathroom.id!) { result in
                switch result {
                case .success(let stats):
                    completion(stats)
                case .failure(let error):
                    print("Failed to fetch review stats: \(error)")
                }
            }
        }
    }
    
    func fetchBathroomTags(for bathroom: BathroomApi, completion: @escaping ([Bool]) -> Void) {
        let tags = getBathroomTags(bathroom: bathroom)
        completion(tags)
    }
    
    func updateReviewAndRatingStatus(api: ApiManager, bathroom: BathroomApi, completion: @escaping (GetRatingStats, Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.fetchReviewStats(api : api , bathroom: bathroom) { stats in
                DispatchQueue.main.async {
                    api.getHasRated(id: bathroom.id!) { result in
                        switch result {
                        case .success(let hasRated):
                            self.getRev(api : api , idb: bathroom.id!)
                            completion(stats, hasRated)
                        case .failure(let error):
                            print("Failed to fetch review status: \(error)")
                            completion(stats, false)
                        }
                    }
                }
            }
        }
    }
    
    func resetAddParams(){
        nameNewAnnotation = ""
        descNewAnnotation = ""
        optionsDropDown = ["Public", "Bar", "Restaurant", "Shop"]
        imagesNewAnnotation = []
        restrictionsArray = [false, false, false]
    }
    
    
    
    func addAnnotationServer(element : BathroomApi){
        allPoints.append(BathroomApi(id: element.id, photos: element.photos, name: element.name, address: element.address, coordinates: element.coordinates, place_type: element.place_type, is_for_disabled: element.is_for_disabled, is_free: element.is_free, is_for_babies: element.is_for_babies, tags: element.tags, updated_at: element.updated_at))
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
    
       
    func searchAndAdd(api: ApiManager) {
        let baseDist = ((-383.5 * currentZoom + 5027.5) * 10 / 100) / (20 - currentZoom) + 1
        let dist: Double
        
        switch baseDist {
        case ..<1:
            dist = 1
        case ..<16.5:
            dist = baseDist
        case ..<20:
            dist = baseDist * 4.7
        case ..<22:
            dist = baseDist * 15
        case ..<23.4:
            dist = baseDist * 30
        default:
            dist = baseDist * 100
        }
                
        api.getBathroomsNearToYou(lat: self.centerLat, long: self.centerLong, distance: dist) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.allPoints.removeAll()
                
                switch result {
                case .success(let array):
                    if !array.isEmpty {
                        array.forEach { self.addAnnotationServer(element: $0) }
                    }
                    self.isLoading = false
                case .failure(let error):
                    print("Error fetching bathrooms: \(error)")
                    self.isLoading = false
                }
            }
        }
    }
    
    func firstTimeFunction(api : ApiManager){
        let locationManager = CLLocationManager()
        centerLat = Double((locationManager.location?.coordinate.latitude) ?? 0)
        centerLong = Double((locationManager.location?.coordinate.longitude) ?? 0)
        currentZoom = 13.0
        DispatchQueue.main.async {
            self.searchAndAdd(api: api)
            self.firstTime = false
        }
    }
    
    func notFirstTimeFunction(api : ApiManager){
        cameraChangeTimer?.invalidate()
        cameraChangeTimer = Timer.scheduledTimer(withTimeInterval:  0.5, repeats: false) { [weak self] _ in
            self?.isLoading = true
            self?.searchAndAdd(api: api)
            
        }
    }
    
    func startCameraChangeTimer(api : ApiManager) {
        if firstTime {
            firstTimeFunction(api: api)
        }else{
            notFirstTimeFunction(api: api)
        }
        
    }
    
    func sendReview(api : ApiManager, cleanStar : [Stars], comfortStar : [Stars] , moodStar : [Stars], idB : String){
        let lastIndexClean = cleanStar.lastIndex(where: { $0.selected  })! + 1
        let lastIndexComfort = comfortStar.lastIndex(where: { $0.selected })! + 1
        let lastIndexAccessibility = moodStar.lastIndex(where: { $0.selected })! + 1
        print(descNewAnnotation)
        
        api.addReview(idB: idB, parameters: AddRating(cleanliness_rating: lastIndexClean, comfort_rating: lastIndexComfort, accessibility_rating: lastIndexAccessibility, review: descNewAnnotation))
    }
    
    
    func getRev(api : ApiManager, idb: String){
        api.getReviews(idB: idb) { result in
            switch result {
            case .success(let reviews):
                self.names = reviews.results!
                
            case .failure(let error):
                print("Failed to fetch reviews: \(error)")
                self.names = []
            }
        }
    }
    
    
    
    func fetchBathroomTags(bathroom: BathroomApi) -> [Bool] {
        return getBathroomTags(bathroom: bathroom)
    }


    func updateBathroomInfo(api: ApiManager, bathroom: BathroomApi, completion: @escaping ([Bool], String) -> Void) {
        let tags = fetchBathroomTags(bathroom: bathroom)
        api.getRevStats(idB: bathroom.id!) { res in
            switch res {
            case .success(let stats):
                completion(tags, stats.overall_rating)
            case .failure(let error):
                print("Failed to fetch review stats: \(error)")
                completion(tags, "")
            }
        }
    }
    
    func handleConfirmAnnotation(api: ApiManager, cleanStar: [Stars], comfortStar: [Stars], moodStar: [Stars], dismiss: @escaping () -> Void, showError: Binding<Bool>, textError: Binding<String>, clicked: Binding<Bool>) {
        if !clicked.wrappedValue && nameNewAnnotation != "" && descNewAnnotation != "" {
            clicked.wrappedValue = true
            
            dismiss()
            
            let type = optionsDropDown[0].lowercased()
            canMove = true
            customMinZoom = 2
            newLocationAdded = true
            
            DispatchQueue.main.async {
                self.sendPointToServer(name: self.nameNewAnnotation, type: type, image: self.imagesNewAnnotation, restrictions: self.restrictionsArray, api: api) { result in
                    if result != "" {
                        self.sendReview(api: api, cleanStar: cleanStar, comfortStar: comfortStar, moodStar: moodStar, idB: result)
                        self.resetAddParams()
                        dismiss()
                        clicked.wrappedValue = false
                    } else {
                        clicked.wrappedValue = false
                    }
                }
            }
        } else if !clicked.wrappedValue {
            if nameNewAnnotation == "" && descNewAnnotation != "" {
                showError.wrappedValue = true
                textError.wrappedValue = "Name is required"
            } else if nameNewAnnotation != "" && descNewAnnotation == "" {
                showError.wrappedValue = true
                textError.wrappedValue = "Comment is required"
            } else if nameNewAnnotation == "" && descNewAnnotation == "" {
                showError.wrappedValue = true
                textError.wrappedValue = "Name and comment are required"
            }
        }
    }

    
    
   
    
}


