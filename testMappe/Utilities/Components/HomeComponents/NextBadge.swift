import SwiftUI
import SDWebImageSwiftUI


struct NextBadge: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var tabBarSelection: TabBarSelection
    @State var badges: [BadgesInfo] = []
    
    var nextBadge: BadgesInfo? {
        badges.filter { !$0.is_completed }
              .sorted {
                  if $0.completion == $1.completion {
                      return $0.badge_name < $1.badge_name
                  }
                  return $0.completion > $1.completion
              }
              .first
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Next badge")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                Spacer()
            }
            if let badge = nextBadge {
                HStack {
                    VStack(alignment: .leading, spacing: -12) {
                        Text(badge.badge_name)
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                        Text("\(badge.completion)%")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 48, fontColor: .accent)
                    }
                    .padding(.leading, 16)
                    .padding(.top, 6)
                    Spacer()
                    WebImage(url: URL(string: "\(api.url)\(badge.badge_photo!)"), options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                        .resizable()
                        .frame(width: 58, height: 58)
                        .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: 86)
                .background(Color.cLightBrown50)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Text("No upcoming badges")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    .frame(maxWidth: .infinity, minHeight: 84)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .onTapGesture {
            self.tabBarSelection.selectedTab = 3
            self.tabBarSelection.selectedBadge = nextBadge!.badge_name
        }
        .padding(.horizontal, 20)
        .task {
            api.getBadges { resp in
                switch resp {
                case .success(let arr):
                    badges = arr
                case .failure(let error):
                    print("Failed to load badges: \(error)")
                }
            }
        }
    }
}
