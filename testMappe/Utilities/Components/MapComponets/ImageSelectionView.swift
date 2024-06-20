import SwiftUI
import PhotosUI


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
