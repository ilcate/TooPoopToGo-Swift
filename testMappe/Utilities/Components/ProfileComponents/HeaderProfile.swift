import SwiftUI

struct HeaderProfile: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    let screenName: String
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Image("BackArrow")
                    .uiButtonStyle(backgroundColor: name == "" ? .white : .cLightBrown)
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                
                Text(screenName)
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                    .padding(.trailing, name.isEmpty ? 44 : 0)
                Spacer()
                
                if !name.isEmpty {
                    ShareLink(item: "Hi, search for @\(name) in Too Poop To Go; it's worth it, I promise.🥺💩") {
                        Image("Share")
                            .uiButtonStyle(backgroundColor: .cLightBrown)
                    }
                }
            }
            .padding(.top, 8)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
