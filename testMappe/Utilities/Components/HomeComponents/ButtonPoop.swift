import SwiftUI

struct ButtonPoop : View {
    var text: String
    
    var body: some View {
        
        HStack(spacing: 6){
            if text != "Done"{
                Image("DropAPoop")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 26, height: 26)
            }
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: text != "Done" ? .accent : .white)
                .frame(height: 26)
        }.padding(.leading, text != "Done" ? 7 : 12).padding(.trailing, text != "Done" ? 8.5 : 12).padding(.vertical, 5)
            .background(text != "Done" ? .white : .cPurpura)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
        
    }
}
