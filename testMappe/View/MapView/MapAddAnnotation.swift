import SwiftUI
import PhotosUI

struct SheetAddAn: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var isTexting: IsTexting
    
    var mapViewModel: MapModel
    var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    
    @State private var photosPikerItems: [PhotosPickerItem] = []
    @State var nameNewAnnotation: String = ""
    @State var openSheetUploadImage = false
    @State var descNewAnnotation: String = ""
    @State var imagesNewAnnotation : [UIImage] = []
    @State private var selectedIconIndex = 0
    @State private var optionsDropDown = ["Public", "Bar", "Restaurant", "Shop"]
    
    var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Image("BackArrow")
                    .uiButtonStyle(backgroundColor: .cLightBrown)
                    .onTapGesture {
                        if isTexting.texting == true {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            isTexting.texting = false
                        } else {
                            isTexting.page = false
                            dismiss()
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
    
    var ratingsView: some View {
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
    
    var commentView: some View {
        VStack(alignment: .leading) {
            Text("Leave a comment")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            TextField("Insert here", text: $descNewAnnotation)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(.capsule)
        }
    }
    
    var locationNameView: some View {
        VStack(alignment: .leading) {
            Text("Location Name")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            TextField("Insert here", text: $nameNewAnnotation)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(.capsule)
        }
    }
    
    var confirmButtonView: some View {
        VStack {
            
            Text("Confirm Annotation")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
                .frame(maxWidth: .infinity, maxHeight: 46)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 1000))
                .padding(.horizontal, 20)
                .padding(.top, -8)
                .onTapGesture {
                    mapViewModel.addAnnotation(icon: "💩", name: nameNewAnnotation, image: imagesNewAnnotation)
                    isTexting.page = false
                    dismiss()
                }
        }
        
    }
    
    var body: some View {
        VStack {
            headerView
            ScrollView {
                VStack(spacing: 16) {
                    locationNameView
                    typeSelectionView(optionsDropDown: $optionsDropDown)
                    commentView
                    imageSelectionView(imagesNewAnnotation: $imagesNewAnnotation, openSheetUploadImage: $openSheetUploadImage, photosPikerItems: $photosPikerItems)
                    restrictionsView()
                    ratingsView
                   
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .padding(.bottom, isTexting.texting == true ? 350 : 0)
            }
            .background(.cLightBrown)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $openSheetUploadImage, onDismiss: {
                openSheetUploadImage = false
            }) {
                ZStack {
                    Color.cLightBrown.ignoresSafeArea(.all)
                    AddImageSheet(photosPickerItems: $photosPikerItems, imagesNewAnnotation:  $imagesNewAnnotation)
                        .presentationDetents([.fraction(0.26)])
                        .presentationCornerRadius(18)
                }
                
            }
            
            .padding(.top, -20)
            .padding(.bottom, -8)
        }
        
        .ignoresSafeArea(.all, edges: [.bottom])
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear{
            isTexting.page = true
        }
        
        if !isTexting.texting {
            CustomDividerView()
                .padding(.bottom, 8)
            confirmButtonView
        }
        
        
    }
}


struct typeSelectionView:  View {
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


struct restrictionsView:  View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Restrictions")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            VStack {
                HStack {
                    Text("Disable Allowed?")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                    Spacer()
                    Image("CheckBox")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 20, height: 20)
                }
                HStack {
                    Text("For Newborns")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                    Spacer()
                    Image("CheckBoxChecked")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 20, height: 20)
                }
                HStack {
                    Text("Pay to Use?")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                    Spacer()
                    Image("CheckBox")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 20, height: 20)
                }
                
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}


struct imageSelectionView:  View {
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
