import SwiftUI
import SDWebImageSwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BadgeView: View {
    @EnvironmentObject var api: ApiManager
    @State var openDetailSheet = false
    @State var tappedId = ""
    @State var completed = false
    @State var com = 0
    @State var completedDate = ""

    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State var badges = [BadgesInfo(badge_id: "", badge_name: "", badge_photo: "", is_completed: false, date_completed: "", completion: 0)]
    
    var body: some View {
        VStack {
            HeadersViewPages(PageName: "Badges")
            Spacer()
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(badges, id: \.self) { badge in
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
                            tappedId = badge.badge_id
                            com = badge.completion
                            completed = badge.is_completed
                            openDetailSheet = true
                            completedDate = formattedDate(badge.date_completed) 
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
                    badges = arr
                case .failure(let error):
                    print("Failed to load badges: \(error)")
                }
            }
        }
        .sheet(isPresented: $openDetailSheet) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                BadgeDetail(id: $tappedId, com: $com, completed: $completed, completedDate: $completedDate)
                    .presentationDetents([.fraction(0.58)])
                    .presentationCornerRadius(18)
            }
        }
    }
}

