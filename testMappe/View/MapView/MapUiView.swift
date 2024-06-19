import SwiftUI
import Alamofire
import Lottie

struct MapButtonsView: View {
    @EnvironmentObject var mapViewModel: MapModel
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @FocusState private var isFocused: Bool  // Define FocusState

    var body: some View {
        ZStack {
            VStack {
                LoadingAndNoResultsView()
                Spacer()
            }

            VStack {
                SearchBarView(isFocused: $isFocused)  // Pass FocusState binding
                if mapViewModel.search {
                    SearchResultsView()
                }
                HStack {
                    if !mapViewModel.search {
                        Spacer()
                        ResetPositionButton()
                    }
                }
                if !mapViewModel.search {
                    AddAnnotationView()
                }
            }
            .ignoresSafeArea(.all, edges: [.bottom])
            .padding(.horizontal, 20)
            .padding(.bottom, isTexting.texting ? 0 : 6)
            .background(mapViewModel.search ? Color.black.opacity(0.3) : Color.black.opacity(0))
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }

            if mapViewModel.newLocationAdded {
                NewLocationAddedView()
            }
        }
//        .sheet(isPresented: $mapViewModel.openSheetFilters, onDismiss: {
//            mapViewModel.openSheetFilters = false
//        }) {
//            ZStack {
//                Color.cLightBrown.ignoresSafeArea(.all)
//                SheetManageSearch()
//                    .presentationDetents([.fraction(0.58)])
//                    .presentationCornerRadius(18)
//            }
//        }
    }
}
