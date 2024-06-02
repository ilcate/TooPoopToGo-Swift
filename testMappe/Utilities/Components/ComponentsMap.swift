
import SwiftUI
import PhotosUI

struct FiltersScroller: View {
    @EnvironmentObject var mapViewModel : MapModel
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

struct RatingsStars: View {
    var RatingName: String
    @Binding var RatingStars: [Stars]
    
    var body: some View {
        HStack{
            Text(RatingName)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
            Spacer()
            HStack(spacing: 4){
                ForEach(RatingStars.indices, id: \.self) { index in
                    Image(RatingStars[index].selected ? "StarFill" : "StarEmpty")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            RatingStars.indices.forEach { idx in
                                RatingStars[idx].selected = idx <= index ? true : false
                            }
                        }
                }
            }

        }
    }
}


struct RatingsView: View {
    @Binding var cleanStar : [Stars]
    @Binding var comfortStar : [Stars]
    @Binding var moodStar : [Stars]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ratings")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            VStack {
                RatingsStars(RatingName: "Cleanliness", RatingStars: $cleanStar)
                RatingsStars(RatingName: "Comfort", RatingStars: $comfortStar)
                RatingsStars(RatingName: "Accessible", RatingStars: $moodStar)
                
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct RestrictionsView: View {
    @Binding var restrictions: [Bool]
    
    private let restrictionLabels = [
        "Disable Allowed?", "For Newborns", "Pay to Use?"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Restrictions")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            
            VStack {
                ForEach(restrictionLabels.indices, id: \.self) { index in
                    HStack {
                        Text(restrictionLabels[index])
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                        Spacer()
                        Image(!restrictions[index] ? "CheckBox" : "CheckBoxChecked")
                            .resizable()
                            .foregroundStyle(.accent)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                restrictions[index].toggle()
                            }
                    }
                }
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct ImageSelectionView: View {
    @Binding var imagesNewAnnotation: [UIImage]
    @Binding var openSheetUploadImage: Bool
    @Binding var photosPickerItems: [PhotosPickerItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            if imagesNewAnnotation.isEmpty {
                ImageUploadView(openSheetUploadImage: $openSheetUploadImage)
            } else {
                ChangeImageView(imagesNewAnnotation: $imagesNewAnnotation, openSheetUploadImage: $openSheetUploadImage)
            }
        }
        
    }
}


struct ImageUploadView:  View {
    @Binding var openSheetUploadImage: Bool
    
    var body: some View {
        Text("Add an Image")
            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
            .padding(.bottom, -2)
        HStack {
            Text("Upload")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .white)
            Spacer()
            Image("UploadArrow")
                .frame(width: 28, height: 28)
                .foregroundStyle(.white)
                .padding(.trailing, -4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 17)
        .background(.cGreen)
        .clipShape(.capsule)
        .onTapGesture {
            openSheetUploadImage.toggle()
        }
    }
}


struct ChangeImageView: View {
    @Binding var imagesNewAnnotation: [UIImage]
    @Binding var openSheetUploadImage: Bool
    
    @State private var selectedImageIndices: Set<Int> = []

    var body: some View {
        Text("Change Image")
            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
            .padding(.bottom, -2)
        HStack {
            Text("Current image")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accentColor)
            Spacer()
            ForEach(imagesNewAnnotation.indices, id: \.self) { index in
                let image = imagesNewAnnotation[index]
                if selectedImageIndices.contains(index) {
                    Image("Close")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .background(.cLightBrown)
                        .foregroundStyle(.accent)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedImageIndices.remove(index)
                            imagesNewAnnotation.remove(at: index)
                        }
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedImageIndices.insert(index)
                        }
                }
            }
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 20)
        .background(Color.white)
        .clipShape(Capsule())
        .onTapGesture {
            openSheetUploadImage.toggle()
        }
    }
}

struct TypeSelectionView:  View {
    @Binding var optionsDropDown: [String]
    @State private var editDropDown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Type")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            HStack {
                Text(optionsDropDown[0])
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accentColor)
                Spacer()
                Image("LightArrow")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.accent)
                    .rotationEffect(editDropDown ? .zero : .degrees(180))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 17)
            .background(.white)
            .clipShape(.capsule)
            .onTapGesture {
                withAnimation(.bouncy) {
                    editDropDown.toggle()
                }
            }
            
            if editDropDown {
                ForEach(optionsDropDown.indices.dropFirst(), id: \.self) { index in
                    let element = optionsDropDown[index]
                    HStack {
                        Text(element)
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accentColor)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(Capsule())
                    .onTapGesture {
                        optionsDropDown.remove(at: index)
                        optionsDropDown.insert(element, at: 0)
                        withAnimation(.bouncy) {
                            editDropDown = false
                        }
                    }
                }
            }
        }
    }
}

struct CoverDef: View {
    var body: some View {
        Image("noPhoto")
            .resizable()
            .resizableImageStyleSmall()
    }
}
