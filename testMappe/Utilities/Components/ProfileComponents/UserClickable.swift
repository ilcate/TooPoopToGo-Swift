import SwiftUI


struct UserClickable: View {
    @Binding var user: UserInfoResponse
    @EnvironmentObject var api: ApiManager
    
    var body: some View {
        NavigationLink(destination: ProfileView(id: user.id, isYourProfile: user.id == api.personalId ? true : false)) {
            HStack {
                ProfileP(link: user.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "", size: 40, padding: 0)
                    .padding(.trailing, 8)
                    .padding(.leading, 12)
                Text(user.username.capitalized)
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                    .padding(.bottom, 1)
                Spacer()
                Image("LightArrow")
                    .resizable()
                    .rotationEffect(.degrees(90))
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 12)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 20)
        }
    }
}
