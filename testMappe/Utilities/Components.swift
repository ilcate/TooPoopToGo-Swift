import SwiftUI
import PhotosUI


struct CustomDividerView: View {
    var body: some View {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightGray)
    }
}

struct SmallTag: View {
    var text : String
    
    var body: some View {
        HStack(spacing: 2){
            Image("\(text)Stroke")
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(.accent)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: Color.accent)
        }
        .padding(.vertical, 5.5).padding(.leading, 5).padding(.trailing, 7)
        .background(.cLightBrown)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
}

struct UpperSheet: View {
    @Environment(\.dismiss) var dismiss
    var text : String
    var pBottom : CGFloat
    var pHor : CGFloat
    
    var body: some View {
        HStack {
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
            Spacer()
            Image("Close")
                .resizable()
                .foregroundStyle(.accent)
                .padding(4)
                .background(.white)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .onTapGesture {
                    dismiss()
                }
        }.padding(.bottom, pBottom).padding(.horizontal, pHor)
    }
    
    
}


struct FiltersScroller: View {
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
                    HStack(spacing: 6){
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
                    .padding(.leading, 9)
                    .padding(.trailing, 11)
                    .background(filtersArray[index].selected == false ? Color.cLightBrown : Color.accent)
                    .clipShape(Capsule())
                }
            }.padding(.horizontal, 20)
        }

    }
}


struct FullRoundedButton: View {
    var text : String
    
    var body: some View {
        Text(text)
            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
            .padding(.horizontal, 20)
    }
}


struct RatingsStars: View {
    var RatingName: String
    @State var RatingStars: [Stars]
    
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
    var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ratings")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            VStack {
                RatingsStars(RatingName: "Cleanliness", RatingStars: cleanStar)
                RatingsStars(RatingName: "Comfort", RatingStars: comfortStar)
                RatingsStars(RatingName: "Mood", RatingStars: moodStar)
                
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



struct ImageSelectionView:  View {
    @Binding var imagesNewAnnotation: [UIImage]
    @Binding var openSheetUploadImage: Bool
    @Binding var photosPikerItems: [PhotosPickerItem]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if imagesNewAnnotation.isEmpty {
                ImageUploadView(openSheetUploadImage: $openSheetUploadImage)
            } else {
                ChangeImageView(imagesNewAnnotation: $imagesNewAnnotation, openSheetUploadImage: $openSheetUploadImage )
            }
        }
        .onChange(of: photosPikerItems) { _, _ in
            Task {
                for item in photosPikerItems{
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            if imagesNewAnnotation.count <= 4 {
                                imagesNewAnnotation.append(image)
                                openSheetUploadImage = false
                            }
                        }
                    }
                }
                
                photosPikerItems.removeAll()
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


struct ChangeImageView:  View {
    @Binding var imagesNewAnnotation: [UIImage]
    @Binding var openSheetUploadImage: Bool
    
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
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .onTapGesture {
                        if let indexToRemove = imagesNewAnnotation.firstIndex(where: { $0 == image }) {
                            imagesNewAnnotation.remove(at: indexToRemove)
                        }
                    }
            }
            
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 20)
        .background(.white)
        .clipShape(.capsule)
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


struct TextFieldCustom:  View {
    @Binding var stateVariable : String
    @State var name : String
    @FocusState private var isFocused
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                .padding(.bottom, -2)
            TextField("Insert here", text: $stateVariable)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(.capsule)
                .focused($isFocused)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .overlay(
                    Capsule()
                        .stroke(.accent, lineWidth: isFocused ? 3 : 0)
                )
        }
    }
}

struct HeaderView:  View {
    @EnvironmentObject var isTexting: IsTexting
    @ObservedObject var mapViewModel: MapModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("BackArrow")
                    .uiButtonStyle(backgroundColor: .cLightBrown)
                    .onTapGesture {
                        print(isTexting.page)
                        if isTexting.page == true{
                            if isTexting.texting == true {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                isTexting.texting = false
                            } else {
                                isTexting.page = false
                                dismiss()
                            }
                        }else{
                            mapViewModel.canMoveCheck(duration: 0)
                        }
                        
                    }
                Spacer()
                Text("Add a Toilet")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 24, fontColor: .accentColor)
                    .padding(.trailing, 44)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: 74)
            .background(.white)
            
            VStack(spacing: 0) {
                CustomDividerView()
            }
            .padding(.top, -8)
            .frame(maxWidth: .infinity, maxHeight: 12)
        }
    }
}


struct HeadersViewPages: View {
     var PageName: String
    
    var body: some View {
        HStack{
            NavigationLink(destination: ProfileView()) {
                Image("Profile")
                    .uiButtonStyle(backgroundColor: .white)
            }
            Spacer()
            Text(PageName)
                .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
            Spacer()
            NavigationLink(destination: SettingsView()) {
                Image("Settings")
                    .uiButtonStyle(backgroundColor: .white)
            }
            
        }.padding(.horizontal, 20).padding(.top, 8)
    }
}

struct ButtonPoop : View {
    var text: String
    
    var body: some View {
        HStack(spacing: 6){
            Image("DropAPoop")
                .renderingMode(.original)
                .resizable()
                .frame(width: 26, height: 26)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .accent)
        }.padding(.leading, 7).padding(.trailing, 8.5).padding(.vertical, 5)
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
    }
}


struct FeedNotification : View {
    var name: String
    var time: String
    var badgeName: String
    var isFriendRequest : Bool
    
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                
                Image("ImagePlaceHolder3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: -1.5){
                    Text(name)
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                    Text(isFriendRequest ? "has requested to follow you." : "has earned a new badge: \(badgeName)" )
                        .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .accent)
                }.padding(.top, -2)
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            
            HStack(alignment: .bottom){
                Text(time)
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .cLightBrown50)
                    .padding(.bottom, -2.5)
                Spacer()
                if isFriendRequest{
                    ButtonFeed(text: "Accept")
                    ButtonFeed(text: "Decline")
                    
                }else{
                    ButtonFeed(text: "View Badge")
                    ButtonFeed(text: "Cheer")
                }
                    
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

        }
        
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}


struct ButtonFeed: View {
    var text : String
    var body: some View {
        if text != "Cheer" {
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: text == "View Badge" || text == "Decline" ? .white : .cLightBrown)
                .padding(.vertical, 5).padding(.horizontal, 8)
                .background(text == "View Badge" || text == "Decline" ? .cLightBrown50 : .accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }else{
            HStack(spacing: 4){
                Image("LikedStroke")
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                Text(text)
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .cLightBrown)
            }.padding(.vertical, 5).padding(.horizontal, 8)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        
    }
}
