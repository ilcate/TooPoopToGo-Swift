import SwiftUI
import PhotosUI

struct AddImageSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var photosPickerItems: [PhotosPickerItem]
    @Binding var imagesNewAnnotation: [UIImage]
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    
    @State var isMaxFivePhotos: Bool

    var maxPhotoLimit: Int {
        isMaxFivePhotos ? 5 : 1
    }

    var body: some View {
        VStack {
            UpperSheet(text: "Upload an Image!", pBottom: 12 , pHor: 0)
            
            HStack {
                PhotosPicker(selection: $photosPickerItems, maxSelectionCount: maxPhotoLimit - imagesNewAnnotation.count, matching: .images) {
                    Text("Upload from your gallery")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .white)
                    Spacer()
                    Image("UploadArrow")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                .onChange(of: photosPickerItems) { oldItems, newItems in
                    for item in newItems {
                        loadTransferable(from: item) { result in
                            switch result {
                            case .success(let image):
                                if let image = image {
                                    DispatchQueue.main.async {
                                        if imagesNewAnnotation.count < maxPhotoLimit {
                                            imagesNewAnnotation.append(image)
                                        }
                                        dismiss()
                                    }
                                }
                            case .failure(let error):
                                print("Error loading image: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.accentColor)
            .clipShape(Capsule())
            
            Button(action: {
                if imagesNewAnnotation.count < maxPhotoLimit {
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
            .background(imagesNewAnnotation.count < maxPhotoLimit ? Color.accentColor : Color.accentColor.opacity(0.3))
            .clipShape(Capsule())
            .disabled(imagesNewAnnotation.count >= maxPhotoLimit)
            
            Text("You can add max \(maxPhotoLimit) image\(maxPhotoLimit > 1 ? "s" : "")")
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $showCamera, onDismiss: {
            if let image = selectedImage {
                DispatchQueue.main.async {
                    if imagesNewAnnotation.count < maxPhotoLimit {
                        imagesNewAnnotation.append(image)
                        dismiss()
                    }
                }
            }
        }) {
            accessCameraView(selectedImage: $selectedImage)
        }
    }
    
    private func loadTransferable(from item: PhotosPickerItem, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let uiImage = UIImage(data: data) {
                    completion(.success(uiImage))
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
