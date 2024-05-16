import SwiftUI
import PhotosUI

struct SheetAddAn: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var isTexting: IsTexting
    @ObservedObject var mapViewModel: MapModel
 
    
    var body: some View {
        VStack {
            HeaderView(mapViewModel: mapViewModel)
            ScrollView {
                VStack(spacing: 16) {
                    LocationView(nameNewAnnotation: $mapViewModel.nameNewAnnotation)
                    TypeSelectionView(optionsDropDown: $mapViewModel.optionsDropDown)
                    CommentView(descNewAnnotation : $mapViewModel.descNewAnnotation)
                    ImageSelectionView(imagesNewAnnotation: $mapViewModel.imagesNewAnnotation, openSheetUploadImage: $mapViewModel.openSheetUploadImage, photosPikerItems: $mapViewModel.photosPikerItems)
                    RestrictionsView()
                    RatingsView()
                   
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .padding(.bottom, isTexting.texting == true ? 350 : 0)
            }
            .background(.cLightBrown)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $mapViewModel.openSheetUploadImage, onDismiss: {
                mapViewModel.openSheetUploadImage = false
            }) {
                ZStack {
                    Color.cLightBrown.ignoresSafeArea(.all)
                    AddImageSheet(photosPickerItems: $mapViewModel.photosPikerItems, imagesNewAnnotation:  $mapViewModel.imagesNewAnnotation)
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
                    mapViewModel.addAnnotation(icon: "💩", name: mapViewModel.nameNewAnnotation, image: mapViewModel.imagesNewAnnotation)
                    isTexting.page = false
                    dismiss()
                }
        }
        
        
    }
}

