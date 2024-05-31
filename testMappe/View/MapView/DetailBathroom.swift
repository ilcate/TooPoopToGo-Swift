
import SwiftUI

struct DetailBathroom: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel: MapModel
    @State private var openSheetNavigate = false
    @State private var openSheetAddReview = false
    @State var informationStat = GetRatingStats(overall_rating: "0", cleanliness_rating: "0", comfort_rating: "0", accessibility_rating: "0", review_count: 0)
    @State var bathroom: BathroomApi
    @State var arrOfTags : [Bool] = [false, false, false, false, false, false, false, false ]

    var body: some View {
        VStack {
            ImageSliderDetailBathroom(bathroom: bathroom)
            VStack(spacing: 0) {
                HStack {
                    Text(bathroom.name!.capitalized)
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 30, fontColor: .accent)
                    Spacer()
                }
                HStack(spacing: 4) {
                    Image("PinHole")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 12, height: 16)
                        .foregroundStyle(.accent)
                    Text(formatAddress(bathroom.address ?? ""))
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, bathroom.photos!.count > 1 ? -4 : -10)
            .padding(.bottom, 8)
            .task {
                api.getRevStats(idB: bathroom.id!) { result in
                    switch result {
                    case .success(let stats):
                        informationStat = stats
                    case .failure(let error):
                        print("Failed to fetch review stats: \(error)")
                    }
                }
            }
            

            ScrollView(.horizontal) {
                DisplayTagsB(arrBool: arrOfTags, limit: 8)
                    .padding(.horizontal, 20)
            }
            .task{
                arrOfTags = getBathroomTags(bathroom: bathroom)
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 4)
            .padding(.top, -4)

            
            if informationStat.review_count > 0 {
                RatingsBathroomDetail(informationStat: $informationStat)
            } else {
                Text("Loading ratings...")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                    .frame(maxWidth: .infinity, minHeight: 105)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.cLightBrown, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
            }

            Spacer()
            ReviewsBathroomDetail(openSheetNavigate: $openSheetNavigate, openSheetAddReview: $openSheetAddReview, api: api, idBathroom: bathroom.id!)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .sheet(isPresented: $openSheetNavigate, onDismiss: {
            openSheetNavigate = false
        }) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                SheetNavigate(bathroom: bathroom)
                    .presentationDetents([.fraction(0.30)])
                    .presentationCornerRadius(18)
            }
        }
        .sheet(isPresented: $openSheetAddReview, onDismiss: {
            openSheetAddReview = false
        }) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                SheetAddReview(mapViewModel: mapViewModel, idB: bathroom.id!)
                    .presentationDetents([.fraction(0.48)])
                    .presentationCornerRadius(18)
            }
        }
    }
}
