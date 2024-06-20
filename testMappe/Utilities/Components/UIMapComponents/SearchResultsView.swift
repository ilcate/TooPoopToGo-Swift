
import SwiftUI

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
