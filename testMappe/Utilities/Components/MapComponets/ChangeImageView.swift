import SwiftUI

struct ChangeImageView: View {
    @Binding var imagesNewAnnotation: [UIImage]
    @Binding var openSheetUploadImage: Bool
    
    @State private var selectedImageIndices: Set<Int> = []

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
                if selectedImageIndices.contains(index) {
                    Image("Close")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .background(.cLightBrown)
                        .foregroundStyle(.accent)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedImageIndices.remove(index)
                            imagesNewAnnotation.remove(at: index)
                        }
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedImageIndices.insert(index)
                        }
                }
            }
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 20)
        .background(Color.white)
        .clipShape(Capsule())
        .onTapGesture {
            openSheetUploadImage.toggle()
        }
    }
}
