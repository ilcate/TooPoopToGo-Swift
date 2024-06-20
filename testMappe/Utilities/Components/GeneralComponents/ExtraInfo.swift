import SwiftUI

struct ExtraInfo: View {
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel : MapModel
    @State var bathroomInfo = BathroomApi()
    let bathroomID: String
    
    var body: some View {
        NavigationLink(destination: DetailBathroom( bathroom: BathroomApi(id: bathroomInfo.id, photos: bathroomInfo.photos, name: bathroomInfo.name, address: bathroomInfo.address, coordinates: bathroomInfo.coordinates, place_type: bathroomInfo.place_type, is_for_disabled: bathroomInfo.is_for_disabled, is_free: bathroomInfo.is_free, is_for_babies: bathroomInfo.is_for_babies, tags: bathroomInfo.tags, updated_at: bathroomInfo.updated_at))){
            HStack {
                VStack(alignment: .leading) {
                    Text(bathroomInfo.name?.capitalized ?? "Loading")
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                        .padding(.top, -2)
                    Text(getStreet(bathroomInfo.address ?? "Loading address"))
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                }
                Spacer()
                
                CustomAsyncImage(
                    imageUrlString:  bathroomInfo.photos?.first?.photo!,
                    placeholderImageName: "noPhoto",
                    size: CGSize(width: 65, height: 65),
                    shape: .rectangle(cornerRadius: 8),
                    maxFrame: false
                )
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.cLightBrown)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: 85)
            .task {
                api.getSingleBathroom(id: bathroomID) { resp in
                    switch resp {
                    case .success(let responseB):
                        bathroomInfo = responseB
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
    }
}
