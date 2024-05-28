
import SwiftUI

struct DeatailImageDef: View {
    var body: some View {
        Image("noPhoto")
            .resizable()
            .resizableImageStyleBig()
    }
}

struct ImageSliderDetailBathroom: View {
    @EnvironmentObject var api : ApiManager
    @State var bathroom : BathroomApi
    @State private var currentImage : Photos?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            ScrollView(.horizontal){
                LazyHStack(spacing: 0){
                    if !bathroom.photos!.isEmpty {
                        ForEach(Array(bathroom.photos!.enumerated()), id: \.1.self) { index, _ in
                            if let photos = bathroom.photos, !photos.isEmpty, let photo = photos[index].photo, let url = URL(string: "\(api.url)\(photo)") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .resizableImageStyleBig()
                                } placeholder: {
                                    DeatailImageDef()
                                }
                            } else {
                                DeatailImageDef()
                            }
                        }
                    }else{
                        DeatailImageDef()
                    }
                    
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $currentImage, anchor: .leading)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea(.all, edges: .top)
            
            VStack{
                HStack{
                    Image("BackArrow")
                        .uiButtonStyle(backgroundColor: .white)
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                    
                    Image("Share")
                        .uiButtonStyle(backgroundColor: .white)
                        .onTapGesture {
                            print("cercare di capire come farla")
                            
                        }
                }.padding(.top, 8)
                Spacer()
            }.padding(.horizontal, 20)
            
            VStack {
                Spacer()
                withAnimation(.smooth) {
                    
                    HStack{
                        HStack(spacing: 6) {
                            ForEach(bathroom.photos!, id: \.self) { imageName in
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(imageName == currentImage ? Material.ultraThick : Material.ultraThin)
                                
                            }
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 3.5)
                        
                        Spacer()
                        
                        
                    }
                }
            }
            .padding(.bottom, 16)
            .padding(.leading, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 280)
        .onAppear{
            currentImage = bathroom.photos![0]
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RatingsBathroomDetail: View {
    @Binding var informationStat : GetRatingStats
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text( informationStat.review_count == 0 ? "Has no reviews" : informationStat.review_count == 1 ? "With \(informationStat.review_count) review" :   informationStat.review_count > 1 ? "With \(informationStat.review_count) reviews" : "Has no reviews")
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 20, fontColor: .accent)
                Spacer()
                HStack(spacing: 4){
                    Image("StarFill")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.accentColor)
                    Text(informationStat.overall_rating)
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 22, fontColor: .accent)
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 30)
            .padding(.horizontal, 12)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightBrown)
            HStack {
                VStack(spacing:1){
                    Text("Cleanliness")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                    HStack(spacing: 0.5){
                        ForEach(0..<5) { index in
                            Image("StarFill")
                                .resizable()
                                .foregroundStyle(.accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: 30)
                Rectangle()
                    .frame(maxWidth: 2, maxHeight: .infinity)
                    .foregroundStyle(.cLightBrown)
                    .ignoresSafeArea(.all)
                VStack(spacing:1){
                    Text("Comfort")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                    HStack(spacing: 0.4){
                        ForEach(0..<5) { index in
                            Image("StarFill")
                                .resizable()
                                .foregroundStyle(.accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: 30)
                Rectangle()
                    .frame(maxWidth: 2, maxHeight: .infinity)
                    .foregroundStyle(.cLightBrown)
                    .ignoresSafeArea(.all)
                VStack(spacing:1){
                    Text("Accessibility")
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 15, fontColor: .accent)
                    HStack(spacing: 0){
                        ForEach(0..<5) { index in
                            Image("StarFill")
                                .resizable()
                                .foregroundStyle(.accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                }
                .padding(.horizontal, -2)
                .frame(maxWidth: .infinity, maxHeight: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: 55)
            .padding(.top, -10)
            .padding(.horizontal, 12)
            .ignoresSafeArea(.all)
            
            
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 105)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.cLightBrown, lineWidth: 2)
        )
        .padding(.horizontal, 20).padding(.vertical, 6)
    }
}

struct ReviewsBathroomDetail: View {
    @State private var names: [Review] = []
    @Binding var openSheetNavigate: Bool
    @Binding var openSheetAddReview: Bool
    @State var reviewsArray: Result<[Review]?, Error>? = nil
    @State var api: ApiManager
    let idBathroom: String

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 2)
                .foregroundStyle(.cLightGray)
            VStack {
                HStack {
                    Text("Location Reviews")
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                    Spacer()
                    HStack(spacing: 1) {
                        Image("Close")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                            .rotationEffect(.degrees(45))
                        Text("Add")
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: .white)
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .background(.cGreen)
                    .clipShape(Capsule())
                    .onTapGesture {
                        openSheetAddReview = true
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 2)
                
                ReviewsScroller(reviews: names)
                
                Spacer()
                
                VStack {
                    FullRoundedButton(text: "Bring me there!")
                        .onTapGesture {
                            openSheetNavigate = true
                        }
                }
                Spacer()
                
            }
            .task {
                api.getReviews(idB: idBathroom) { result in
                    switch result {
                    case .success(let reviews):
                        names = reviews.reversed()
                    case .failure(let error):
                        print("Failed to fetch reviews: \(error)")
                        names = []
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cLightBrown)
        .padding(.top, 6)
    }
}
