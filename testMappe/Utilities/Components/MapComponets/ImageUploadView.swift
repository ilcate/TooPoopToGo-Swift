
import SwiftUI

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
