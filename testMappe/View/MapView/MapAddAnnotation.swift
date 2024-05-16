import SwiftUI
import PhotosUI

struct SheetAddAn: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var isTexting: IsTexting
    
    @ObservedObject var mapViewModel: MapModel
 
    @State private var photosPikerItems: [PhotosPickerItem] = []
    @State var nameNewAnnotation: String = ""
    @State var openSheetUploadImage = false
    @State var descNewAnnotation: String = ""
    @State var imagesNewAnnotation : [UIImage] = []
    @State private var selectedIconIndex = 0
    @State private var optionsDropDown = ["Public", "Bar", "Restaurant", "Shop"]
   
    
    var body: some View {
        VStack {
            HeaderView(mapViewModel: mapViewModel)
            ScrollView {
                VStack(spacing: 16) {
                    LocationView(nameNewAnnotation: $nameNewAnnotation)
                    TypeSelectionView(optionsDropDown: $optionsDropDown)
                    CommentView(descNewAnnotation :$descNewAnnotation)
                    ImageSelectionView(imagesNewAnnotation: $imagesNewAnnotation, openSheetUploadImage: $openSheetUploadImage, photosPikerItems: $photosPikerItems)
                    RestrictionsView()
                    RatingsView()
                   
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
            FullRoundedButton(text: "Confirm Annotation")
                .padding(.top, -8)
                .onTapGesture {
                    mapViewModel.addAnnotation(icon: "💩", name: nameNewAnnotation, image: imagesNewAnnotation)
                    isTexting.page = false
                    dismiss()
                }
        }
        
        
    }
}

