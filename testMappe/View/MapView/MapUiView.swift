import SwiftUI
import Alamofire
import Lottie

struct MapButtonsView: View {
    @ObservedObject var mapViewModel: MapModel
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @FocusState private var isFocused: Bool
    
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if mapViewModel.isLoading {
                        LottieView(animation: .named("DotAnim.json"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .configure({ lottieAnimationView in
                                lottieAnimationView.contentMode = .scaleAspectFill
                            })
                            .frame(width: 50, height: 34)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 1000))
                            .padding(.horizontal, 8)
                            .padding(.top, 6)
                            
                    }
                    
                    if mapViewModel.allPoints.count == 0  {
                        if !mapViewModel.isLoading {
                            Text("No results in this area")
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 14, fontColor: .accent)
                                .frame(width: 185, height: 32)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                                .padding(.horizontal, 16).padding(.vertical, 6)
                        }
                        
                    }
                }.padding(.top, 8)
                Spacer()
            }
            
            VStack{
                HStack{
                    ZStack{
                        HStack {
                            TextField("Search", text: $mapViewModel.searchingInput)
                                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                                .padding(.trailing, -24)
                                .focused($isFocused)
                                .onChange(of: mapViewModel.searchingInput) { oldValue, newValue in
                                    api.searchBathroom( stringToSearch: mapViewModel.searchingInput)
                                }
                            Image("FIlters")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.accent)
                                .onTapGesture {
                                    mapViewModel.openSheetFilters = true
                                }
                        }
                        .frame(maxWidth: mapViewModel.search ? .infinity : 44)
                        .padding(.horizontal, mapViewModel.search ? 16 : 0)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.accent, lineWidth: isFocused ? 3 : 0)
                        )
                        
                        if  !mapViewModel.search {
                            NavigationLink(destination: ProfileView()) {
                                Image("Profile")
                                    .uiButtonStyle(backgroundColor: .white)
                            }
                            
                            
                        }
                    }
                    Spacer()
                    
                    Image(mapViewModel.search ? "Close" : "Search")
                        .uiButtonStyle(backgroundColor: .white)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)){
                                mapViewModel.search.toggle()
                                mapViewModel.removeSelection()
                                if isTexting.texting == true {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    isTexting.texting = false
                                    
                                } else {
                                    isTexting.page = false
                                    
                                }
                                
                            }
                        }
                    
                    
                }.padding(.top, 8)
                
                
                
                HStack{
                    Spacer()
                    if  !mapViewModel.search {
                        Image("ResetPosition")
                            .uiButtonStyle(backgroundColor: .white)
                            .onTapGesture {
                                mapViewModel.resetAndFollow(z: 13)
                            }
                        
                    }
                    
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        if !mapViewModel.search {
                            Image("AddAnnotation")
                                .frame(width: 60, height: 60)
                                .background(.white)
                                .clipShape(Circle())
                                .foregroundStyle(.accent)
                                .onTapGesture {
                                    mapViewModel.resetAndFollow(z: 18)
                                    mapViewModel.canMoveCheck(duration: 0.5)
                                }
                                .padding(.bottom,   mapViewModel.tappedAnnotation() ?  6 : 72 )
                        }
                    }
                    if mapViewModel.tappedAnnotation() {
                        withAnimation(.snappy){
                            InformationOfSelectionView(mapViewModel: mapViewModel)
                                .padding(.bottom, 6 )
                        }
                    }
                    
                }
                
                
            }
            .ignoresSafeArea(.all, edges: [.bottom] )
            .padding(.horizontal, 20)
            .padding(.bottom,  isTexting.texting ? 0 : 6)
            .background(mapViewModel.search ? .black.opacity(0.3) : .black.opacity(0))
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            if mapViewModel.newLocationAdded == true {
                VStack{
                    VStack{
                        VStack(alignment: .leading ,spacing: 10){
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
                        } .padding(.horizontal, 20).padding(.bottom, 16).padding(.top, 6)
                        
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 36)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.2))
            }
            
        }.sheet(isPresented: $mapViewModel.openSheetFilters, onDismiss: {
            mapViewModel.openSheetFilters = false
        }) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                SheetManageSearch(mapViewModel: mapViewModel)
                    .presentationDetents([.fraction(0.58)])
                    .presentationCornerRadius(18)
            }
            
        }
        
        
        
        
    }
}

