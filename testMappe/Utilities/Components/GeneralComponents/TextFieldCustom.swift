

import SwiftUI

struct TextFieldCustom: View {
    @Binding var stateVariable: String
    @State var name: String
    @FocusState private var isFocused
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                .padding(.bottom, -2)
            TextField("Insert here", text: $stateVariable)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                .onChange(of: stateVariable) { oldValue, newValue in
                    let limit = (name == "Location Name") ? 20 : 110
                    if newValue.count > limit {
                        stateVariable = String(newValue.prefix(limit))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())
                .focused($isFocused)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .overlay(
                    Capsule()
                        .stroke(Color.accent, lineWidth: isFocused ? 3 : 0)
                )
        } .ignoresSafeArea(.keyboard)
    }
}
