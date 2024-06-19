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

struct LoadingAndNoResultsView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        HStack {
            if mapViewModel.isLoading {
                LottieView(animation: .named("DotAnim.json"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                    .configure({ lottieAnimationView in
                        lottieAnimationView.contentMode = .scaleAspectFill
                    })
                    .frame(width: 50, height: 34)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
            }

            if mapViewModel.allPoints.isEmpty && !mapViewModel.isLoading {
                Text("No results in this area")
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 14, fontColor: .accent)
                    .frame(width: 185, height: 32)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 1000))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
            }
        }
        .padding(.top, 8)
    }
}

struct SearchBarView: View {
    @EnvironmentObject var mapViewModel: MapModel
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @FocusState.Binding var isFocused: Bool  // Change to FocusState.Binding

    var body: some View {
        HStack {
            ZStack {
                HStack {
                    TextField("Search", text: $mapViewModel.searchingInput)
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                        .allowsHitTesting(mapViewModel.search ? true : false)
                        .padding(.trailing, -24)
                        .focused($isFocused)  // Use FocusState binding
                        .onTapGesture {
                            if isFocused {
                                isTexting.texting = true
                                isTexting.page = true
                            }
                        }
                        .onChange(of: isFocused) { _, newValue in
                            if !isFocused {
                                isTexting.page = false
                            }
                        }
                        .onChange(of: mapViewModel.searchingInput) { _, newValue in
                            if !newValue.isEmpty {
                                api.searchBathroom(stringToSearch: newValue) { resp in
                                    mapViewModel.searchedElements = resp
                                }
                            }
                        }
                }
                .frame(maxWidth: mapViewModel.search ? .infinity : 44)
                .padding(.horizontal, mapViewModel.search ? 16 : 0)
                .padding(.vertical, 9)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.accent, lineWidth: isFocused ? 3 : 0)
                )

                if !mapViewModel.search {
                    NavigationLink(destination: ProfileView(isYourProfile: true)) {
                        Image("Profile")
                            .uiButtonStyle(backgroundColor: .white)
                    }
                }
            }
            Spacer()

            Image(mapViewModel.search ? "Close" : "Search")
                .uiButtonStyle(backgroundColor: .white)
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        mapViewModel.search.toggle()
                        mapViewModel.removeSelection()
                        if isTexting.texting {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            isTexting.texting = false
                        } else {
                            isTexting.page = false
                        }
                    }
                }
        }
        .padding(.top, 8)
    }
}

struct SearchResultsView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                if !mapViewModel.searchingInput.isEmpty {
                    switch mapViewModel.searchedElements {
                    case .success(let bathrooms):
                        if let bathrooms = bathrooms, !bathrooms.isEmpty {
                            ForEach(bathrooms, id: \.id) { element in
                                InformationOfSelectionView(bathroom: BathroomApi(id: element.id, photos: element.photos, name: element.name, address: element.address, coordinates: element.coordinates, place_type: element.place_type, is_for_disabled: element.is_for_disabled, is_free: element.is_free, is_for_babies: element.is_for_babies, tags: element.tags, updated_at: element.updated_at), mapViewModel: mapViewModel)
                            }
                        } else {
                            NoResultsView()
                        }
                    case .failure, .none:
                        NoResultsView()
                    }
                } else {
                    NoResultsView()
                }
            }
            .padding(.top, 8)
        }
        .padding(.bottom, 1)
        .scrollIndicators(.hidden)
    }
}

struct NoResultsView: View {
    var body: some View {
        Text("No results")
            .normalTextStyle(
                fontName: "Manrope-SemiBold",
                fontSize: 16,
                fontColor: .cLightBrown
            )
    }
}

struct ResetPositionButton: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        Image("ResetPosition")
            .uiButtonStyle(backgroundColor: .white)
            .onTapGesture {
                mapViewModel.resetAndFollow(z: 13)
            }
    }
}

struct AddAnnotationView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        VStack(spacing: 6) {
            Spacer()
            HStack {
                Spacer()
                Image("AddAnnotation")
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .foregroundStyle(Color.accent)
                    .onTapGesture {
                        mapViewModel.resetAndFollow(z: 18)
                        mapViewModel.canMoveCheck(duration: 0.5)
                    }
            }
            if mapViewModel.tappedAnnotation() {
                withAnimation(.snappy) {
                    InformationOfSelectionView(bathroom: mapViewModel.selected!, mapViewModel: mapViewModel)
                        .opacity(mapViewModel.selected?.name != "" ? 1 : 0)
                        .onChange(of: mapViewModel.viewport) { _, new in
                            if !mapViewModel.checkCoordinates() {
                                mapViewModel.removeSelection()
                            }
                        }
                        .padding(.top, 6)
                }
            }
        }
        .padding(.bottom, 72)
    }
}

struct NewLocationAddedView: View {
    @EnvironmentObject var mapViewModel: MapModel

    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Thank you for your submission!")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 26, fontColor: .accent)
                        .frame(maxHeight: 80)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, -8)
                    Text("Our moderators will review it shortly. If all goes well, the bathroom will be online within a couple of days.")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                        .padding(.bottom, 4)
                    FullRoundedButton(text: "Gotcha!")
                        .padding(.horizontal, -20)
                        .onTapGesture {
                            mapViewModel.newLocationAdded = false
                        }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .padding(.top, 6)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 36)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
    }
}
