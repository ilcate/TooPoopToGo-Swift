
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
            HStack {
                Text("Upload an Image!")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                Spacer()
                Image("Close")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        dismiss()
                    }
            }.padding(.bottom, 12)
                HStack {
                    PhotosPicker(selection: $photosPickerItems, maxSelectionCount: 5 - $imagesNewAnnotation.count ,matching: .images) {
                        Text("Upload from your gallery")
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .white)
                        Spacer()
                        Image("UploadArrow")
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                    /*PhotosPicker("Upload From Gallery", selection: $photosPickerItems, maxSelectionCount: 5, selectionBehavior: .ordered, matching: .images)
                            .font(.custom("Manrope-SemiBold", size: 18))
                            .foregroundStyle(.white)*/
                    
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

struct accessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: accessCameraView
    
    init(picker: accessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.picker.selectedImage = selectedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.picker.selectedImage = originalImage
        }
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

//TODO: POSSIBILITà DI FARE TANTE FOTO DI FILA E METTERE IL MASSIMO A 5
