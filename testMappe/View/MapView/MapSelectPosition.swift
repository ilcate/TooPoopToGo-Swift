import SwiftUI

struct MapSelectPositionView: View {
    @ObservedObject var mapViewModel: MapModel
    @EnvironmentObject var isTexting: IsTexting
    
    var body: some View {
        
        ZStack{
            VStack{
                Image("marker")
                    .resizable()
                    .frame(width: 40, height: 49)
                    .padding(.bottom, 50)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(.black.opacity(0.2))
            .allowsHitTesting(false)
            
            VStack{
                HeaderView(mapViewModel: mapViewModel)
                Spacer()
            }
            
            VStack{
                Spacer()
                NavigationLink(destination: SheetAddAn(mapViewModel: mapViewModel)) {
                    FullRoundedButton(text: "Confirm position")
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                }
                
                .background(.white)
            }
            .ignoresSafeArea(.all)
        }
        .padding(.bottom, -4)
        
    }
}
