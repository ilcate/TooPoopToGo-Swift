import SwiftUI

struct MapButtonsView: View {
    @ObservedObject var mapViewModel: MapModel
    @EnvironmentObject var isTexting: IsTexting
    
    
    
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    TextField("Search", text: $mapViewModel.searchingInput)
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                        .frame(maxWidth: mapViewModel.search ? .infinity : 44)
                        .padding(.horizontal, mapViewModel.search ? 12 : 0)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
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
            Spacer()
            VStack{
                HStack{
                    Spacer()
                    if !mapViewModel.search {
                        Image("AddAnnotation")
                            .frame(width: 60, height: 60)
                            .background(.white)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                mapViewModel.resetAndFollow(z: 18)
                                mapViewModel.canMoveCheck(duration: 0.5)
                            }
                    }
                }.padding(.bottom, mapViewModel.tappedAnnotation() ? 6 : 72)
                //InformationOfSelectionView(mapViewModel: mapViewModel)
                if mapViewModel.tappedAnnotation() {
                    withAnimation(.bouncy){
                        InformationOfSelectionView(mapViewModel: mapViewModel)
                    }
                }
                
            }
        }
        .ignoresSafeArea(.all, edges: [.bottom] )
        .padding(.horizontal, 20)
        .background(mapViewModel.search ? .black.opacity(0.3) : .black.opacity(0))
        .padding(.bottom,  isTexting.texting ? 0 : 6)
        
        
        
    }
}

