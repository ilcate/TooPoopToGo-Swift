import SwiftUI
import PhotosUI

struct SheetAddAn: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var isTexting: IsTexting
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel: MapModel
 
    
    var body: some View {
        VStack {
            HeaderView(mapViewModel: mapViewModel)
            ScrollView {
                VStack(spacing: 16) {
                    TextFieldCustom(stateVariable: $mapViewModel.nameNewAnnotation,  name: "Location Name" )
                    TypeSelectionView(optionsDropDown: $mapViewModel.optionsDropDown)
                    TextFieldCustom(stateVariable : $mapViewModel.descNewAnnotation ,  name: "Leave a comment")
                    ImageSelectionView(imagesNewAnnotation: $mapViewModel.imagesNewAnnotation, openSheetUploadImage: $mapViewModel.openSheetUploadImage, photosPikerItems: $mapViewModel.photosPikerItems)
                    RestrictionsView(restrictions: $mapViewModel.restrictionsArray)
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
                    //)mapViewModel.addAnnotation(name: mapViewModel.nameNewAnnotation, image: mapViewModel.imagesNewAnnotation)
                    mapViewModel.sendPointToServer(name: mapViewModel.nameNewAnnotation, type: mapViewModel.optionsDropDown[0], image : mapViewModel.imagesNewAnnotation, restrictions: mapViewModel.restrictionsArray, api: api)
//                    isTexting.page = false
//                    dismiss()
                }
        }
        
        
    }
}

