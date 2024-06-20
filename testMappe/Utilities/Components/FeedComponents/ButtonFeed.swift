
import SwiftUI

struct ButtonFeed: View {
    var text : String
    var body: some View {
        if text != "Cheer" {
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: text == "View Badges" || text == "View Bathroom" || text == "Accepted" ?  .accent.opacity(0.7) : .cLightBrown)
                .padding(.vertical, 5).padding(.horizontal, 8)
                .background(text == "View Badges" || text == "View Bathroom" || text == "Accepted" ? .cLightBrown50.opacity(0.3) : text == "Decline" ? .cMidBrown : .accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }else{
            HStack(spacing: 4){
                Image("LikedStroke")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 14)
                Text(text)
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .cLightBrown)
            }.padding(.vertical, 5).padding(.horizontal, 8)
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        
    }
}
