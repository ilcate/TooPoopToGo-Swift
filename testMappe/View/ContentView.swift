import SwiftUI
import CoreLocation
@_spi(Experimental) import MapboxMaps

class TabBarSelection: ObservableObject {
    //pubilished fa si che il valore sia reattivo
    @Published var selectedTab: Int = 0
    @Published var destination: [CGFloat] = []
}

class IsTexting: ObservableObject {
    @Published var texting = false
    @Published var page = false
}

struct ContentView: View {
    @StateObject var tabBarSelection = TabBarSelection()
    @StateObject var isTexting = IsTexting()
    //istanziazione dell'object
    //meglio degli state per oggetti complessi e è in grado di durare ed esistere anche se la view muore
    //poiché non si lega a nessuna
    
    var body: some View {
        NavigationStack{
            ZStack{
                TabView(selection: $tabBarSelection.selectedTab) {
                    MapView()
                        .tabItem {
                            Image("MapTB")
                        }
                        .padding(.bottom, isTexting.texting ? -50 : 5)
                        .tag(0)
                    HomeView()
                        .tabItem {
                            Image("HomeTB")
                        }
                        .padding(.bottom, 10)
                        .tag(1)
                    FeedView()
                        .tabItem {
                            Image("FeedTB")
                        }
                        .padding(.bottom, 10)
                        .tag(2)
                    BadgeView()
                        .tabItem {
                            Image("BadgeTB")
                        }
                        .padding(.bottom, 10)
                        .tag(3)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    isTexting.texting = true
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isTexting.texting = false
                    }
                }
                
                
                VStack{
                    Spacer()
                    if isTexting.page == false{
                        CustomDividerView()
                            .padding(.bottom, isTexting.texting ? 0 : 59)
                    }
                }
                
            }
        }
        .environmentObject(tabBarSelection)
        .environmentObject(isTexting)//fa si che tutti i figli abbiatno all'interno l'istanza dell'object e sia uguale in tutte
        
    }
}

