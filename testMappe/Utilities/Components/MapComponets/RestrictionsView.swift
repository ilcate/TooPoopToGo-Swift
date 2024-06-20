import SwiftUI

struct RestrictionsView: View {
    @Binding var restrictions: [Bool]
    
    private let restrictionLabels = [
        "Disable Allowed?", "For Newborns", "Pay to Use?"]
    private let restrictionImages = [
        "Accessible", "Babies", "Free"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Restrictions")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accentColor)
                .padding(.bottom, -2)
            
            VStack {
                ForEach(restrictionLabels.indices, id: \.self) { index in
                    HStack {
                        Image("\(restrictionImages[index])Stroke")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, -2)
                            .foregroundStyle(.accent)
                        Text(restrictionLabels[index])
                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                        Spacer()
                        Image(!restrictions[index] ? "CheckBox" : "CheckBoxChecked")
                            .resizable()
                            .foregroundStyle(.accent)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                restrictions[index].toggle()
                            }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
