

import SwiftUI

struct FiltersScroller: View {
    @ObservedObject var mapViewModel : MapModel
    @State var filtersArray = [
        Filters(image: UIImage(named: "AccessibleCircle"), name: "Accessible", selected: false),
        Filters(image: UIImage(named: "FreeCircle"), name: "Free", selected: false),
        Filters(image: UIImage(named: "BabiesCircle"), name: "Babies", selected: false),
        Filters(image: UIImage(named: "NewestCircle"), name: "Newest", selected: false),
        Filters(image: UIImage(named: "PublicCircle"), name: "Public", selected: false),
        Filters(image: UIImage(named: "ShopCircle"), name: "Shop", selected: false),
        Filters(image: UIImage(named: "RestaurantCircle"), name: "Restaurant", selected: false),
        Filters(image: UIImage(named: "BarCircle"), name: "Bar", selected: false)
    ]
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack{
                ForEach(filtersArray.indices, id: \.self) { index in
                    HStack(spacing: 6){
                        Image(uiImage: filtersArray[index].image!)
                            .resizable()
                            .frame(width: 26, height: 26)
                            .clipShape(.circle)
                        Text(filtersArray[index].name)
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 15, fontColor: filtersArray[index].selected == false ? Color.accent : Color.white)
                    }
                    .onTapGesture {
                        filtersArray[index].selected.toggle()
                        
                        let selectedFilter = filtersArray[index].name
                        
                        if filtersArray[index].selected {
                            for i in filtersArray.indices {
                                if filtersArray[i].name != selectedFilter {
                                    filtersArray[i].selected = false
                                }
                            }
                            mapViewModel.filterSelected = selectedFilter
                        } else {
                            mapViewModel.filterSelected = "Roll"
                        }
                    }
                    
                    .padding(.vertical, 7)
                    .padding(.leading, 9)
                    .padding(.trailing, 11)
                    .background(filtersArray[index].selected == false ? Color.cLightBrown : Color.accent)
                    .clipShape(Capsule())
                }
            }.padding(.horizontal, 20)
        }

    }
}
