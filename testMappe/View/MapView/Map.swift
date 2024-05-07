import SwiftUI
import PhotosUI
import CoreLocation
@_spi(Experimental) import MapboxMaps

struct MapView: View {
    @EnvironmentObject var tabBarSelection: TabBarSelection
    @Environment(\.colorScheme) var colorScheme
    @StateObject var mapViewModel = MapModel()
    
    
    var body: some View {
       
            ZStack{
                Map(viewport: $mapViewModel.viewport) {
                    ForEvery(mapViewModel.allPoints){ ann in
                        let annotationBinding = Binding.constant(ann)
                        MapViewAnnotation(coordinate: CLLocationCoordinate2D(latitude: ann.latitude, longitude: ann.longitude)) {
                            Annotation(mapViewModel: mapViewModel, ann: annotationBinding)
                        }

                        .allowOverlapWithPuck(true)//fa si che il punto dell'utente sia sotto all'annotation
                        .allowOverlap(mapViewModel.currentZoom >= 13 ? true : false)
                        .ignoreCameraPadding(false)
                        
                    }
                    
                    Puck2D(bearing: .heading)
                        .showsAccuracyRing(true)
                }
                .onMapTapGesture(perform: { MapContentGestureContext in
                    
                    //print(mapViewModel.centerLat)
                    //print(MapContentGestureContext.coordinate.latitude)
                    
                    mapViewModel.removeSelection()
                    
                    // print(mapViewModel.tappedAnnotation())
                    
                    
                    //if canMove == false{
                    //allPoints.append(AnnotationServer(text: "💩", latitude: MapContentGestureContext.coordinate.latitude, longitude: MapContentGestureContext.coordinate.longitude, zoom: 14, name: "Test"))
                    //canMove = true
                })
                .mapStyle(MapStyle.standard(lightPreset: StandardLightPreset(rawValue: colorScheme == .dark ? "night" : "day")))
                .cameraBounds(CameraBoundsOptions(maxZoom: 18, minZoom: mapViewModel.customMinZoom))
                .ornamentOptions(OrnamentOptions(scaleBar: ScaleBarViewOptions(visibility: .hidden), compass: CompassViewOptions(visibility: .hidden), logo: LogoViewOptions(margins: .init(x: -10000, y: 0)), attributionButton: AttributionButtonOptions(margins: .init(x: -10000, y: 0))))
                .onCameraChanged(action: { CameraChanged in
                    /*if mapViewModel.isAnimate == false {
                     print("ciao")
                     mapViewModel.removeSelection()
                     }*/
                    mapViewModel.currentZoom = CameraChanged.cameraState.zoom
                    mapViewModel.getCameraCenter(CameraChanged: CameraChanged)
                    
                })
                .additionalSafeAreaInsets(.horizontal, 8)
                .additionalSafeAreaInsets(.top, 16)
                .additionalSafeAreaInsets(.bottom, 24)
                .ignoresSafeArea(.container)
                .onAppear{
                    mapViewModel.checkDestination(istTab : tabBarSelection)
                }
                //.onTapGesture {
                /*if mapViewModel.viewport.camera?.center?.longitude == mapViewModel.selected!.longitude && mapViewModel.viewport.camera?.center?.latitude == mapViewModel.selected!.latitude{
                 
                 mapViewModel.removeSelection()
                 }*/
                
                
                //mapViewModel.removeSelection()
                //}
                
                //.cameraBounds(CameraBoundsOptions(bounds: CoordinateBounds(southwest: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! - 0.006, longitude: (locationManager.location?.coordinate.longitude)! - 0.005), northeast: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.006, longitude: (locationManager.location?.coordinate.longitude)! + 0.0044), infiniteBounds: canMove), maxZoom: customMaxZoom, minZoom: 6))
                //.additionalSafeAreaInsets(Edge.Set, 4)
                
                
                //CustomMapView(mapViewModel: mapViewModel, tabBarSelection: tabBarSelection, userViewport: $mapViewModel.viewport) AAA dovrebbe essere così ma si bugga tutto quindi lo tengo fuori dalla struct
                
                
                if mapViewModel.canMove == true {
                    if !mapViewModel.search{
                        FilterBottom(mapViewModel: mapViewModel)
                    }
                    
                    MapButtonsView(mapViewModel: mapViewModel)
                    VStack{
                        Spacer()
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: 5)
                            .foregroundStyle(.white)
                    }
                }
                
                if mapViewModel.canMove == false {
                    MapSelectPositionView(mapViewModel: mapViewModel)
                        .toolbar(.hidden, for: .tabBar)
                }
                
            }
        }
        
    
}









/*struct CustomMapView: View {
 var mapViewModel: MapModel
 var tabBarSelection: TabBarSelection
 @Binding var userViewport: Viewport
 
 var body: some View {
 Map(viewport: $userViewport) {
 ForEvery(mapViewModel.allPoints){ ann in
 MapViewAnnotation(coordinate: CLLocationCoordinate2D(latitude: ann.latitude, longitude: ann.longitude)) {
 Text(ann.text)
 .frame(width: 30, height: 30)
 .background(Circle().fill(ann == mapViewModel.selected ? Color.black : Color.white ))
 .onTapGesture {
 mapViewModel.moveToDestination(cords: [ann.latitude, ann.longitude, ann.zoom], dur: 0.3)
 mapViewModel.selected = ann
 }
 }
 
 }
 Puck2D(bearing: .heading)
 .showsAccuracyRing(true)
 }
 //.cameraBounds(CameraBoundsOptions(bounds: CoordinateBounds(southwest: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! - 0.006, longitude: (locationManager.location?.coordinate.longitude)! - 0.005), northeast: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.006, longitude: (locationManager.location?.coordinate.longitude)! + 0.0044), infiniteBounds: canMove), maxZoom: customMaxZoom, minZoom: 6))
 
 .cameraBounds(CameraBoundsOptions(maxZoom: 18, minZoom: mapViewModel.customMinZoom))
 //.additionalSafeAreaInsets(Edge.Set, 4)
 .ornamentOptions(OrnamentOptions(scaleBar: ScaleBarViewOptions(visibility: .hidden), compass: CompassViewOptions(visibility: .visible), logo: LogoViewOptions(margins: .init(x: -10000, y: 0)), attributionButton: AttributionButtonOptions(margins: .init(x: -10000, y: 0))))
 .onCameraChanged(action: { CameraChanged in
 mapViewModel.getCameraCenter(CameraChanged: CameraChanged)
 })
 /*.onMapTapGesture(perform: { MapContentGestureContext in
  if canMove == false{
  allPoints.append(AnnotationServer(text: "💩", latitude: MapContentGestureContext.coordinate.latitude, longitude: MapContentGestureContext.coordinate.longitude, zoom: 14, name: "Test"))
  canMove = true
  }
  
  })*/
 .onAppear{
 mapViewModel.checkDestination(istTab : tabBarSelection )
 }
 }
 }*/



