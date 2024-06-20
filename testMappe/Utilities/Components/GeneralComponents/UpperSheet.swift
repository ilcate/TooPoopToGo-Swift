
import SwiftUI

struct UpperSheet: View {
    @Environment(\.dismiss) var dismiss
    var text : String
    var pBottom : CGFloat
    var pHor : CGFloat
    
    var body: some View {
        HStack {
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
            Spacer()
            Image("Close")
                .resizable()
                .foregroundStyle(.accent)
                .padding(4)
                .background(.white)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .onTapGesture {
                    dismiss()
                }
        }.padding(.bottom, pBottom).padding(.horizontal, pHor)
    }
    
    
}
