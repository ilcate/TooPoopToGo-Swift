
import SwiftUI

import PhotosUI


struct AddImageSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var photosPickerItems: [PhotosPickerItem]
    @Binding var imagesNewAnnotation: [UIImage]
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            UpperSheet(text: "Upload an Image!", pBottom: 12 , pHor: 0)
            
            HStack {
                PhotosPicker(selection: $photosPickerItems, maxSelectionCount: 5 - $imagesNewAnnotation.count ,matching: .images) {
                    Text("Upload from your gallery")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .white)
                    Spacer()
                    Image("UploadArrow")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                
            }.padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.accentColor)
                .clipShape(Capsule())
            
            
            
            Button(action: {
                if imagesNewAnnotation.count <= 4 {
                    self.showCamera.toggle()
                }
            }) {
                HStack {
                    Text("Take it now")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .white)
                    Spacer()
                    Image("Camera")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(imagesNewAnnotation.count <= 4 ? Color.accentColor : Color.accentColor.opacity(0.3))
            .clipShape(Capsule())
            
            Text("You can add max 5 images")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $showCamera, onDismiss: {
            if let image = selectedImage {
                imagesNewAnnotation.append(image)
                dismiss()
            }
        }) {
            accessCameraView(selectedImage: $selectedImage)
        }
    }
}

