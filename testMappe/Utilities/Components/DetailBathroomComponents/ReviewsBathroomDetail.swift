
import SwiftUI

struct ReviewsBathroomDetail: View {
    @Binding var openSheetNavigate: Bool
    @Binding var openSheetAddReview: Bool
    @ObservedObject var mapViewModel : MapModel
    @State var reviewsArray: Result<[Review]?, Error>? = nil
    @Binding var userHasRated : Bool
    @State var api: ApiManager
    let idBathroom: String
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightGray)
            VStack {
                HStack {
                    Text("Location Reviews")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    Spacer()
                    if !userHasRated {
                        HStack(spacing: 1) {
                            Image("Close")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(45))
                            
                            
                            Text("Add")
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .white)
                        }
                        
                        
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(.cGreen)
                        .clipShape(Capsule())
                        .onTapGesture {
                            openSheetAddReview = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 2)
                
                ReviewsScroller(reviews: mapViewModel.names, isProfile: false, isShort: true)
                
                Spacer()
                
                VStack {
                    FullRoundedButton(text: "Bring me there!")
                        .onTapGesture {
                            openSheetNavigate = true
                        }
                }
                Spacer()
                
            }
            .task {
                
                mapViewModel.getRev(api: api, idb: idBathroom)
                
                api.getHasRated(id: idBathroom) { result in
                    switch result {
                    case .success(let bool):
                        userHasRated = bool
                    case .failure(let error):
                        print("Failed to fetch review stats: \(error)")
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cLightBrown)
        .padding(.top, 6)
    }
}
