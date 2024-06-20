import SwiftUI

struct ProfilePictureCustom: View {
    var body: some View {
        VStack {
            Image("ProfilePerson")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fill)
                .frame(width: 500, height: 500)
            
        }
        .frame(width: 1000, height: 1000)
        .background(Circle().fill(randomColor()))
        .clipShape(Circle())
    }
}
