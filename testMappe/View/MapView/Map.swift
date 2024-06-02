import SwiftUI
import PhotosUI
import CoreLocation
@_spi(Experimental) import MapboxMaps

struct MapView: View {
    @EnvironmentObject var tabBarSelection: TabBarSelection
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var api: ApiManager
    @StateObject var mapViewModel = MapModel()
    
    var body: some View {
       
            ZStack{
                Map(viewport: $mapViewModel.viewport) {
                    if !mapViewModel.allPoints.isEmpty{
                        ForEvery(mapViewModel.allPoints){ ann in
                            let annotationBinding = Binding.constant(ann)
                            MapViewAnnotation(coordinate: CLLocationCoordinate2D(latitude: (ann.coordinates?.coordinates![1])!, longitude: (ann.coordinates?.coordinates![0])!)) {
                                Annotation( mapViewModel: mapViewModel, ann: annotationBinding)
                            }
                            .allowOverlapWithPuck(true)//fa si che il punto dell'utente sia sotto all'annotation
                            .allowOverlap(mapViewModel.currentZoom >= 14 ? true : false)
                            .ignoreCameraPadding(false)
                        }
                    }
                    
                    Puck2D(bearing: .heading)
                        .showsAccuracyRing(true)
                }
                
                .onStyleLoaded(action: { StyleLoaded in
                        mapViewModel.startCameraChangeTimer(api: api)
                })
                .gestureOptions(.init(pitchEnabled: false))
                .onMapTapGesture(perform: { MapContentGestureContext in
                    mapViewModel.removeSelection()
                })
                .mapStyle(MapStyle.standard(lightPreset: StandardLightPreset(rawValue: colorScheme == .dark ? "night" : "day")))
                .cameraBounds(CameraBoundsOptions(maxZoom: 18, minZoom: mapViewModel.customMinZoom))
                .ornamentOptions(OrnamentOptions(scaleBar: ScaleBarViewOptions(visibility: .hidden), compass: CompassViewOptions(visibility: .hidden), logo: LogoViewOptions(margins: .init(x: -10000, y: 0)), attributionButton: AttributionButtonOptions(margins: .init(x: -10000, y: 0))))
                .onCameraChanged(action: { CameraChanged in
                    mapViewModel.currentZoom = CameraChanged.cameraState.zoom
                    mapViewModel.getCameraCenter(CameraChanged: CameraChanged)
                    mapViewModel.startCameraChangeTimer(api: api)
                })
                .additionalSafeAreaInsets(.horizontal, 8)
                .additionalSafeAreaInsets(.top, 16)
                .additionalSafeAreaInsets(.bottom, 24)
                .ignoresSafeArea(.container)
                .onAppear{
                    mapViewModel.checkDestination(istTab : tabBarSelection)
                }
                
                if mapViewModel.canMove == true {
                    if !mapViewModel.search{
                        VStack{
                            Spacer()
                            FiltersScroller(mapViewModel: mapViewModel)
                                .padding(.bottom, 16)
                                .padding(.top, 4)
                                .frame(maxWidth: .infinity, maxHeight: 70)
                                .background(Color.white)
                                
                        }.padding(.bottom, -5)
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
                    MapSelectPositionView(mapViewModel:mapViewModel)
                        .toolbar(.hidden, for: .tabBar)
                }
                
            }
        }
        
    
}
