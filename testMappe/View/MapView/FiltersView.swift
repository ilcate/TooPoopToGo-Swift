import SwiftUI

struct FilterBottom: View {
    @ObservedObject var mapViewModel : MapModel
    @State var filtersArray = [
        Filters(image: UIImage(named: "TrendingCircle")!, name: "Trending", selected: false),
        Filters(image: UIImage(named: "FreeCircle")!, name: "Free", selected: false),
        Filters(image: UIImage(named: "AccessibleCircle")!, name: "Accessible", selected: false),
        Filters(image: UIImage(named: "LikedCircle")!, name: "Liked", selected: false),
        Filters(image: UIImage(named: "CleanestCircle")!, name: "Cleanest", selected: false),
        Filters(image: UIImage(named: "NewestCircle")!, name: "Newest", selected: false)
    ]
    
    var body: some View {

    

                    
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
}
