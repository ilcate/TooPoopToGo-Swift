import SwiftUI
import CoreLocation
@_spi(Experimental) import MapboxMaps

struct TestView: View {
    @EnvironmentObject var tabBarSelection: TabBarSelection

    var body: some View {
        Text("Go to everest")
            .onTapGesture {
                self.tabBarSelection.destination = [27.986065, 86.922623, 17]
                self.tabBarSelection.selectedTab = 0
            }
    }
}


