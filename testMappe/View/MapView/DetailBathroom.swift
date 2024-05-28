
import SwiftUI

struct DetailBathroom: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api : ApiManager
    
    @State private var openSheetNavigate =  false
    @State private var openSheetAddReview =  false
    
    @State var bathroom : BathroomApi
    
    var body: some View {
        VStack{
            ImageSliderDetailBathroom(bathroom: bathroom)
            
            VStack(spacing: 0){
                HStack{
                    Text(bathroom.name!)
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 30, fontColor: .accent)
                    Spacer()
                }
                HStack( spacing: 4){
                    Image("PinHole")
                        .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                        .resizable()
                        .frame(width: 12, height: 16)
                        .foregroundStyle(.accent)
                    Text(formatAddress(bathroom.address ?? ""))
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                
                    Spacer()
                    
                }
            }
            .padding(.horizontal, 20).padding(.top, -4).padding(.bottom, 8)
            
            ScrollView(.horizontal){
                HStack{
                    SmallTag(text: String(bathroom.place_type!.capitalized))
                    SmallTag(text: "Free")
                    SmallTag(text: "Babies")
                    SmallTag(text: "Accessible")
                    SmallTag(text: "Newest")
                }.padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 4).padding(.top, -4)
            
            RatingsBathroomDetail()
            
            Spacer()
            
            ReviewsBathroomDetail(openSheetNavigate: $openSheetNavigate, openSheetAddReview: $openSheetAddReview, api: api, idBathroom: bathroom.id!)
            
        }.ignoresSafeArea(.all, edges: .bottom)
            .sheet(isPresented: $openSheetNavigate, onDismiss: {
                openSheetNavigate = false
            }) {
                ZStack {
                    Color.cLightBrown.ignoresSafeArea(.all)
                    SheetNavigate(bathroom : bathroom)
                        .presentationDetents([.fraction(0.30)])
                        .presentationCornerRadius(18)
                }
                
            }
            .sheet(isPresented: $openSheetAddReview, onDismiss: {
                openSheetAddReview = false
            }) {
                ZStack {
                    Color.cLightBrown.ignoresSafeArea(.all)
                    SheetAddReview(idB: bathroom.id!)
                        .presentationDetents([.fraction(0.48)])
                        .presentationCornerRadius(18)
                }
                
            }
    }
    
}

