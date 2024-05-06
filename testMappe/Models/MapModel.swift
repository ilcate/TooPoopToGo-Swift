import Foundation
import SwiftUI
import CoreLocation
@_spi(Experimental) import MapboxMaps



final class MapModel: ObservableObject{
    @Published var cords = [45.0, 8.0, 6]
    @Published  var allPoints = [AnnotationServer(text: "💩", latitude: 45.7613222, longitude: 8.690, zoom: 17, name: "Mareblu"),
                                 AnnotationServer(text: "💩", latitude: 45.7613222, longitude: 8.695, zoom: 17, name: "Acqua Fresca"),
                                 AnnotationServer(text: "💩", latitude: 45.461786 , longitude: 9.208970, zoom: 17, name: "Onde Serene"),
                                 AnnotationServer(text: "💩", latitude: 45.461846, longitude:  9.209764, zoom: 17, name: "Arcobaleno Marino"),
                                 AnnotationServer(text: "💩", latitude:  45.461786, longitude: 9.209378, zoom: 17, name: "Fonte Pulita")]
    
    @Published var viewport: Viewport = .followPuck(zoom: 13).padding(.all, 20)
    @Published var selected: AnnotationServer? = AnnotationServer(text: "💩", latitude: 0, longitude: 0, zoom: 0, name: "")
    @Published var canMove = true
    @Published var customMinZoom = 2.0
    @Published var locationManager = CLLocationManager()
    @Published var centerLat = 0.0
    @Published var centerLong = 0.0
    @Published var currentZoom = 0.0
    @Published var openAddSheet = false
    @Published var randomImage =  UIImage(named: "ImagePlaceHolder")
    @Published var justChanged = true
    @Published var search = false
    @Published var searchingInput = ""
    @Published var filterSelected = "Roll"

    //@Published var isAnimate = false
    
    
    
    
    func moveToDestination(cords: [CGFloat], dur : CGFloat){
        let animationDuration = calcDur(cords: cords)
        
        withViewportAnimation(.easeOut(duration: animationDuration)) {
            viewport = .camera( center: CLLocationCoordinate2D(latitude: cords[0], longitude: cords[1]), zoom: cords[2])
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
        selected = AnnotationServer(text: "💩", latitude: 0, longitude: 0, zoom: 0, name: "")
    }
    
    func getCameraCenter(CameraChanged: CameraChanged){
        centerLat = CameraChanged.cameraState.center.latitude
        centerLong = CameraChanged.cameraState.center.longitude
    }
    
    
    func addAnnotation(icon: String, name: String, image: [UIImage?]){
        allPoints.append(AnnotationServer(image: image, text: icon, latitude: centerLat, longitude: centerLong, zoom: 17, name: name))
        canMove = true
        customMinZoom = 2
        openAddSheet = false
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
        if viewport.camera?.center?.latitude == selected!.latitude {
            if viewport.camera?.center?.longitude == selected!.longitude {
                return true
            }
        }
        
        return false
        
        
    }
}
