import SwiftUI
import SDWebImageSwiftUI
import Lottie

struct OtherInformationUser: View {
    @EnvironmentObject var api: ApiManager
    @ObservedObject var profileModel : ProfileModel
    @EnvironmentObject var mapViewModel: MapModel
    let isYourself : Bool
    let userId : String
    
    var body: some View {
        VStack(spacing: 12) {
            if profileModel.loadedBadge && profileModel.loadedRatings && profileModel.loadedToilet {
                VStack(spacing: 8) {
                    HStack {
                        Text("Badges")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Spacer()
                    } .padding(.horizontal, 20)
                    if !profileModel.userBadges.isEmpty{
                        ScrollView(.horizontal){
                            LazyHStack {
                                ForEach(profileModel.userBadges, id: \.self) { badge in
                                    VStack {
                                        if let imageURL = URL(string: "\(api.url)\(badge.badge_photo ?? "")") {
                                            WebImage(url: imageURL, options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                                                .resizable()
                                                .frame(width: 58, height: 58)
                                                .applyGrayscale(badge.is_completed ? 0 : 1)
                                        }
                                        Text(badge.badge_name)
                                            .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 12, fontColor: .accent)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    .padding(8)
                                    .frame(width: 80)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.bottom, 8)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            .frame(height: 105)
                           
                        }.padding(.bottom, -14)
                    }else{
                        Text("No badge completed")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 20)
                            
                    }
                   
                
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Reviews")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Spacer()
                    } .padding(.horizontal, 20)
                    ReviewsScroller(reviews: profileModel.userRatings, isProfile: true, isShort: false)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("Toilet Created")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Spacer()
                    } .padding(.horizontal, 20)
                    if !profileModel.userToilet.isEmpty {
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(profileModel.userToilet, id: \.self) { bathroom in
                                        InformationOfSelectionView(bathroom: bathroom, mapViewModel: mapViewModel)
                                            .padding(.vertical, 3)
                                            .frame(width: 350)
                                    }
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .scrollTargetLayout()
                            }
                            .contentMargins(0, for: .scrollContent)
                            .scrollIndicators(.hidden)
                            .scrollTargetBehavior(.viewAligned)
                        }
                        .padding(.vertical, -1)
                    } else {
                        Text("No bathroom created")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: .accent)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 114)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 20)
                            
                    }
                }
            } else {
                VStack{
                    Spacer()
                    LottieView(animation: .named("LoadingAnimation.json"))
                        .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                        .frame(width: 90, height: 90)
                    Spacer()
                }
                
            }
            
        }
        .padding(.top, -48)
       
        .task {
            profileModel.getToilets(api: api, isSelf: isYourself)
            profileModel.getBadges(api: api, isSelf: isYourself)
            profileModel.getReviews(api: api, isSelf: isYourself)
        }
    }
}
