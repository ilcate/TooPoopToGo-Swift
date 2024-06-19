import SwiftUI

struct InformationOfSelectionView: View {
    var bathroom: BathroomApi
    @EnvironmentObject var api: ApiManager
    @State var loading = false
    @State var arrOfTags: [Bool] = [false, false, false, false, false, false, false, false]
    @State var ovRating = ""
    @StateObject var mapViewModel: MapModel
    
    var body: some View {
        VStack {
            if !bathroom.name!.isEmpty {
                NavigationLink(destination: DetailBathroom(bathroom: bathroom)) {
                    HStack(spacing: 0) {
                        if !loading {
                            
                            CustomAsyncImage(
                                imageUrlString: bathroom.photos?.first?.photo,
                                placeholderImageName: "noPhoto",
                                size: CGSize(width: 88, height: 96),
                                shape: .rectangle(cornerRadius: 8),
                                maxFrame: false
                            )
                            .padding(8)
                            
                        } else {
                            CoverDef()
                        }
                        
                        VStack(alignment: .leading, spacing: -4) {
                            HStack {
                                HStack {
                                    Text(bathroom.name!.capitalized)
                                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 24, fontColor: .accentColor)
                                    Spacer()
                                }
                                
                                Spacer()
                                Image("StarFill")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.accentColor)
                                    .padding(.trailing, -6)
                                Text(ovRating)
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accentColor)
                            }
                            Text(getStreet(bathroom.address ?? ""))
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accentColor)
                            Spacer()
                            DisplayTagsB(arrBool: arrOfTags, limit: 2)
                            
                        }
                        .padding(.trailing, 10)
                        .padding(.bottom, 7).padding(.top, 3)
                        .onAppear {
                            updateInfo()
                        }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity, maxHeight: 110)
                }
            }
        }
        .onChange(of: bathroom) { _, old in
            loading = true
            DispatchQueue.main.async {
                updateInfo()
                loading = false
            }
        }
    }
    
    private func updateInfo() {
        mapViewModel.updateBathroomInfo(api: api, bathroom: bathroom) { tags, rating in
            arrOfTags = tags
            ovRating = rating
        }
    }
}
