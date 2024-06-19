import SwiftUI
import CoreLocation
import WatchKit

struct ContentView: View {
    @StateObject var homeModel = HomeModelWatch()
    @StateObject var api = ApiManagerWatch()
    
    var body: some View {
        VStack {
            HStack {
                Text("Next to you")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
            }
            ScrollView {
                VStack {
                    ForEach(homeModel.nextToYou) { element in
                        VStack {
                            HStack {
                                Text(element.name ?? "Unknown")
                                    .font(.system(size: 17))
                                    .bold()
                                    .padding(.horizontal, 12)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                        }
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            openAppleMaps(bathroom: element)
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
        .ignoresSafeArea()
        .padding(.horizontal, 8)
        .onAppear {
            homeModel.foundNextToYou(api: api)
        }
    }
    
    func openAppleMaps(bathroom: BathroomApi) {
        let latitude = bathroom.coordinates?.coordinates?[1] ?? 0.0
        let longitude = bathroom.coordinates?.coordinates?[0] ?? 0.0
        if let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=d&t=m") {
            WKExtension.shared().openSystemURL(url)
        } else if let fallbackURL = URL(string: "itms-apps://itunes.apple.com") {
            WKExtension.shared().openSystemURL(fallbackURL)
        }
    }
}

struct FullRoundedButton: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}

// Assuming BathroomApi and other required types and classes are defined elsewhere in your code.
