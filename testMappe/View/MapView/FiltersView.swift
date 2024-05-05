import SwiftUI

struct FilterBottom: View {
    @StateObject var mapViewModel = MapModel()
    @State var filtersArray = [
        Filters(image: UIImage(named: "Trending")!, name: "Trending", selected: false),
        Filters(image: UIImage(named: "Free")!, name: "Free", selected: false),
        Filters(image: UIImage(named: "Accessible")!, name: "Accessible", selected: false),
        Filters(image: UIImage(named: "Liked")!, name: "Liked", selected: false),
        Filters(image: UIImage(named: "Cleanest")!, name: "Cleanest", selected: false),
        Filters(image: UIImage(named: "New")!, name: "Newest", selected: false)
    ]
    
    var body: some View {

                VStack {
                    Spacer()

                    
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack{
                            ForEach(filtersArray.indices, id: \.self) { index in
                                HStack {
                                    Image(uiImage: filtersArray[index].image)
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
                                    
                                    print(mapViewModel.filterSelected)
                                }

                                .padding(.vertical, 7)
                                .padding(.leading, 10)
                                .padding(.trailing, 12)
                                .background(filtersArray[index].selected == false ? Color.cUltraLightGray : Color.accent)
                                .clipShape(Capsule())
                            }
                        }.padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .background(Color.white)
                }
                .padding(.bottom, -5)
        
    }
}
