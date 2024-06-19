import SwiftUI
import SDWebImageSwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BadgeView: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var tabBarSelection: TabBarSelection
    @StateObject var badgeModel = BadgeModel()
   

    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
   
    
    var body: some View {
        VStack {
            HeadersViewPages(PageName: "Badges")
            Spacer()
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(badgeModel.badges, id: \.self) { badge in
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
                        .onTapGesture {
                            badgeModel.openBadge(badge: badge)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .background(Color.cLightBrown)
        
        .task {
            badgeModel.getBadges(api: api, tabBarSelection: tabBarSelection)
        }
        .sheet(isPresented: $badgeModel.openDetailSheet, onDismiss: {
            badgeModel.badgeSel = BadgesInfoDetailed(name: "", description: "", badge_requirement_threshold: 0, badge_photo: "")
        }) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                BadgeDetail(id: $badgeModel.tappedId, com: $badgeModel.com, completed: $badgeModel.completed, completedDate: $badgeModel.completedDate, badgeModel : badgeModel)
                    .presentationDetents([.fraction(0.58)])
                    .presentationCornerRadius(18)
            }
        }
    }
}

