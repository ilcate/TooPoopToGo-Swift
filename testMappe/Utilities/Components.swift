import SwiftUI


struct CustomDividerView: View {
    var body: some View {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightGray)
    }
}

struct SmallTag: View {
    var text : String
    
    var body: some View {
        HStack(spacing: 2){
            Image("\(text)Stroke")
                .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(.accent)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: Color.accent)
        }
        .padding(.vertical, 4).padding(.leading, 3).padding(.trailing, 6)
        .background(.cUltraLightGray)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
}
