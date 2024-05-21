import SwiftUI
import CoreLocation
@_spi(Experimental) import MapboxMaps


struct ContentView: View {
    @StateObject var tabBarSelection = TabBarSelection()
    @StateObject var isTexting = IsTexting()
    @StateObject var onBoarding = OnBoarding()
    @StateObject var api = ApiManager()
    @StateObject var oBModel = OnBoardingModel()
    @State private var path: [String] = []
    
    //istanziazione dell'object
    //meglio degli state per oggetti complessi e è in grado di durare ed esistere anche se la view muore
    //poiché non si lega a nessuna
    
    
    var body: some View {
        NavigationStack(path: $path){
            if  !onBoarding.onBoarding && api.userToken == ""{
                
                OnBoardingView(oBModel: oBModel, path: $path)
                    .navigationDestination(for: String.self) { screen in
                        switch screen {
                        case "ChoseLogM":
                            ChoseLogM(path: $path)
                        case "LogIn":
                            LogInAndSignUp(path: $path, isLogIn: true, oBModel: oBModel)
                        case "SignUp":
                            LogInAndSignUp(path: $path, isLogIn: false, oBModel: oBModel)
                        case "InsertOtp":
                            InsertOtp(path: $path, oBModel: oBModel)
                        default:
                            EmptyView()
                        }
            }
            
            }else if  onBoarding.onBoarding && api.userToken == ""{
                Loader()
            } else{
                ZStack{
                    TabView(selection: $tabBarSelection.selectedTab) {
                        MapView()
                            .tabItem {
                                Image("MapTB")
                            }
                            .padding(.bottom, isTexting.texting ? -50 : 5)
                            .tag(1)
                        HomeView()
                            .tabItem {
                                Image("HomeTB")
                            }
                            .padding(.bottom, 10)
                            .tag(0)
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
                
            
          
        }
        
        .environmentObject(tabBarSelection)
        .environmentObject(isTexting)//fa si che tutti i figli abbiatno all'interno l'istanza dell'object e sia uguale in tutte
        .environmentObject(onBoarding)
        .environmentObject(api)
    
}
}

