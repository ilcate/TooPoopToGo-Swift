

import SwiftUI

struct FullRoundedButtonRed: View {
    var text : String
    
    var body: some View {
        Text(text)
            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(.cRed)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
            .padding(.horizontal, 20)
    }
}
