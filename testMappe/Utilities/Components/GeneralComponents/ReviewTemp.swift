
import SwiftUI

struct ReviewTemp: View {
    let review: Review
    let isProfile : Bool
    let isShort : Bool
    @State var ratingAVG = ""
    @EnvironmentObject var api : ApiManager
    @ObservedObject var mapViewModel : MapModel
    
    
    var body: some View {
        
        VStack {
            HStack {
                if !isProfile {
                    NavigationLink(destination: {
                        
                        if review.user.id == api.personalId {
                            ProfileView( isYourProfile: true)
                        } else {
                            ProfileView( id: review.user.id, isYourProfile: false)
                        }
                        
                        
                    }) {
                        HStack {
                            ProfileP(link: review.user.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "", size: 40, padding: 0)
                            VStack(alignment: .leading, spacing: -2) {
                                Text(review.user.username)
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 19, fontColor: .accent)
                                Text(timeElapsedSince(review.createdAt))
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent.opacity(0.4))
                            }
                        }
                    }}else{
                        HStack {
                            ProfileP(link: review.user.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "", size: 40, padding: 0)
                            VStack(alignment: .leading, spacing: -2) {
                                Text(review.user.username)
                                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 19, fontColor: .accent)
                                Text(timeElapsedSince(review.createdAt))
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent.opacity(0.4))
                            }
                        }
                    }
                Spacer()
                HStack(spacing: 4){
                    Image("StarFill")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.accentColor)
                    Text(ratingAVG)
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                }
            }
            .padding(.horizontal, 16)
            
            if !isShort {
                ExtraInfo( mapViewModel: mapViewModel, bathroomID: review.toilet!)
            }
            
            HStack{
                Text(review.review)
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Spacer()
            }.padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity, minHeight: isShort ? 144 : 224, maxHeight: isShort ? 144 : 224)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
        .padding(.trailing, 10)
        .padding(.bottom, -6)
        .onAppear{
            ratingAVG = getAvg(review: review)
        }
    }
    
}
