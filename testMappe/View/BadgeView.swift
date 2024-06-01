import SwiftUI

struct BadgeView: View {
    @EnvironmentObject var api: ApiManager
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State var badges = [BadgesInfo(badge_name: "", badge_photo: "", is_completed: false, date_completed: "")]
    
    var body: some View {
        VStack {
            HeadersViewPages(PageName: "Badges")
            Spacer()
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(badges, id: \.self) { badge in
                        NavigationLink(destination: BadgeDetail()) {
                            VStack {
                                if let badgePhoto = badge.badge_photo,
                                   let imageURL = URL(string: "\(api.url)\(badgePhoto)") {
                                    SVGImageView(url: imageURL)
                                } else {
                                    Image("noPhoto")
                                        .resizable()
                                        .frame(width: 58, height: 58)
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .background(Color.cLightBrown)
        .task {
            api.getBadges { resp in
                switch resp {
                case .success(let arr):
                    print("Successfully loaded badges: \(arr)")
                    badges = arr
                case .failure(let error):
                    print("Failed to load badges: \(error)")
                }
            }
        }
    }
}
