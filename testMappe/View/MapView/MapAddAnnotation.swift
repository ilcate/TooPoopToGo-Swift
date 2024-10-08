import SwiftUI


struct AddBathroom: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var isTexting: IsTexting
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var mapViewModel: MapModel
    @State var cleanStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var comfortStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    @State var moodStar = [Stars(selected: true), Stars(), Stars(), Stars(), Stars()]
    

    @State var showError = false
    @State var textError = "Name and comment are required"
    @State var clicked = false

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    ZStack {
                        HeaderView()
                        if showError {
                            Text(textError)
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .red)
                                .padding(.bottom, -24)
                        }
                    }
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            TextFieldCustom(stateVariable: $mapViewModel.nameNewAnnotation, name: "Location Name")
                            TypeSelectionView(optionsDropDown: $mapViewModel.optionsDropDown)
                            TextFieldCustom(stateVariable: $mapViewModel.descNewAnnotation, name: "Leave a comment")
                            ImageSelectionView(imagesNewAnnotation: $mapViewModel.imagesNewAnnotation, openSheetUploadImage: $mapViewModel.openSheetUploadImage, photosPickerItems: $mapViewModel.photosPikerItems)
                            RestrictionsView(restrictions: $mapViewModel.restrictionsArray)
                            RatingsView(cleanStar: $cleanStar, comfortStar: $comfortStar, moodStar: $moodStar)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .padding(.bottom, isTexting.texting == true ? 350 : 0)
                    }
                    .background(.cLightBrown)
                    .navigationBarBackButtonHidden(true)
                    .sheet(isPresented: $mapViewModel.openSheetUploadImage, onDismiss: {
                        isTexting.page = true
                        mapViewModel.openSheetUploadImage = false
                    }) {
                        ZStack {
                            Color.cLightBrown.ignoresSafeArea(.all)
                            AddImageSheet(photosPickerItems: $mapViewModel.photosPikerItems, imagesNewAnnotation: $mapViewModel.imagesNewAnnotation, isMaxFivePhotos: true)
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
                .onAppear {
                    isTexting.page = true
                }
                .onDisappear{
                    isTexting.page = false
                }

                if !isTexting.texting {
                    CustomDividerView()
                        .padding(.bottom, 8)
                    
                    FullRoundedButton(text: "Confirm Annotation")
                        .padding(.top, -8)
                        .onTapGesture {
                            mapViewModel.handleConfirmAnnotation(api: api, cleanStar: cleanStar, comfortStar: comfortStar, moodStar: moodStar, dismiss: { dismiss() }, showError: $showError, textError: $textError, clicked: $clicked)


                        }
                }
            }
        }
    }
}
