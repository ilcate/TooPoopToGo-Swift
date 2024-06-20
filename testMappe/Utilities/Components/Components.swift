import SwiftUI
import PhotosUI


//TODO: cambia tutti gli state in let se non devono variare

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 2)
            .foregroundStyle(.cLightGray)
    }
}

struct SmallTag: View {
    var text : String
    
    var body: some View {
        HStack(spacing: 2){
            Image("\(text)Stroke")
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(.accent)
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 14, fontColor: Color.accent)
        }
        .padding(.vertical, 5.5).padding(.leading, 5).padding(.trailing, 7)
        .background(.cLightBrown)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    
}

struct UpperSheet: View {
    @Environment(\.dismiss) var dismiss
    var text : String
    var pBottom : CGFloat
    var pHor : CGFloat
    
    var body: some View {
        HStack {
            Text(text)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
            Spacer()
            Image("Close")
                .resizable()
                .foregroundStyle(.accent)
                .padding(4)
                .background(.white)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .onTapGesture {
                    dismiss()
                }
        }.padding(.bottom, pBottom).padding(.horizontal, pHor)
    }
    
    
}


struct FullRoundedButton: View {
    var text : String
    
    var body: some View {
        Text(text)
            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
            .padding(.horizontal, 20)
    }
}


struct FullRoundedButtonRed: View {
    var text : String
    
    var body: some View {
        Text(text)
            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .white)
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(.cRed)
            .clipShape(RoundedRectangle(cornerRadius: 1000))
            .padding(.horizontal, 20)
    }
}





struct TextFieldCustom: View {
    @Binding var stateVariable: String
    @State var name: String
    @FocusState private var isFocused
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                .padding(.bottom, -2)
            TextField("Insert here", text: $stateVariable)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                .onChange(of: stateVariable) { oldValue, newValue in
                    let limit = (name == "Location Name") ? 20 : 110
                    if newValue.count > limit {
                        stateVariable = String(newValue.prefix(limit))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())
                .focused($isFocused)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .overlay(
                    Capsule()
                        .stroke(Color.accent, lineWidth: isFocused ? 3 : 0)
                )
        } .ignoresSafeArea(.keyboard)
    }
}



struct HeaderView:  View {
    @EnvironmentObject var isTexting: IsTexting
    @EnvironmentObject var mapViewModel: MapModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("BackArrow")
                    .uiButtonStyle(backgroundColor: .cLightBrown)
                    .onTapGesture {
                        print(isTexting.page)
                        if isTexting.page == true{
                            if isTexting.texting == true {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                isTexting.texting = false
                            } else {
                                isTexting.page = false
                                dismiss()
                            }
                        }else{
                            mapViewModel.canMoveCheck(duration: 0)
                        }
                        
                    }
                Spacer()
                Text("Add a Toilet")
                    .normalTextStyle(fontName: "Manrope-Bold", fontSize: 24, fontColor: .accentColor)
                    .padding(.trailing, 44)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, maxHeight: 74)
            .background(.white)
            
            VStack(spacing: 0) {
                CustomDividerView()
            }
            .padding(.top, -8)
            .frame(maxWidth: .infinity, maxHeight: 12)
        }
    }
}


struct HeadersViewPages: View {
    var PageName: String
    
    
    var body: some View {
        HStack{
            NavigationLink(destination: ProfileView( isYourProfile: true)) {
                Image("Profile")
                    .uiButtonStyle(backgroundColor: .white)
            }
            Spacer()
            Text(PageName)
                .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
            Spacer()
            NavigationLink(destination: SettingsView()) {
                Image("Settings")
                    .uiButtonStyle(backgroundColor: .white)
            }
            
        }.padding(.horizontal, 20).padding(.top, 8)
    }
}

struct HeadersFeedView: View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var isTexting: IsTexting
    @FocusState private var isFocused: Bool
    @Binding var isSearching: Bool
    @Binding var users: [UserInfoResponse]
    @State var field = ""
    
    var body: some View {
        HStack {
            ZStack{
                TextField("Search friends!", text: $field)
                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                    .padding(.trailing, -24)
                    .focused($isFocused)
                    .onTapGesture {
                        isTexting.texting = true
                        isTexting.page = true
                    }
                    .onChange(of: field) { oldValue, newValue in
                        if !newValue.isEmpty {
                            api.searchUser(stringToSearch: field) { resp in
                                switch resp {
                                case .success(let us):
                                    users = us.results!
                                    print(users)
                                case .failure(let error):
                                    print("Error: \(error)")
                                }
                            }
                        } else {
                            users.removeAll()
                        }
                    }
                    .onChange(of: isFocused) { oldValue, newValue in
                        if !isFocused {
                            isTexting.page = false
                        }
                    }
                
                    .frame(maxWidth: isSearching ? .infinity : 44)
                    .padding(.horizontal, isSearching ? 16 : 0)
                    .padding(.vertical, 9)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(.accent, lineWidth: isFocused ? 3 : 0)
                    )
                
                if !isSearching {
                    HStack{
                        NavigationLink(destination:  ProfileView( isYourProfile: true)) {
                            Image("Profile")
                                .uiButtonStyle(backgroundColor: .white)
                        }
                        
                    }
                    
                }
                
            }
            Spacer()
            if !isSearching {
                Text("Feed")
                    .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
            }
            Spacer()
            Image(isSearching ? "Close" : "Search")
                .uiButtonStyle(backgroundColor: .white)
                .onTapGesture {
                    
                    if isTexting.texting == true {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isTexting.texting = false
                    } else {
                        isTexting.page = false
                    }
                    
                    withAnimation(.easeOut(duration: 0.2)) {
                        isSearching.toggle()
                    }
                    
                    if isSearching == false {
                        users.removeAll()
                    }
                    
                }
        }.padding(.horizontal, 20).padding(.top, 8)
    }
}






struct FeedNotification : View {
    @EnvironmentObject var api: ApiManager
    @EnvironmentObject var tabBarSelection: TabBarSelection
    var notification : ResultFeed
    @State var userInformation = UserInfoResponse(username: "", id: "")
    @ObservedObject var feedModel : FeedModel
    
    
    @State var bathroom =  BathroomApi()
    
    var body: some View {
        VStack{
            HStack{
                if  notification.content_type == "friend_request" {
                    NavigationLink(destination: {
                        if userInformation.id == api.personalId {
                            ProfileView( isYourProfile: true)
                        } else {
                            ProfileView( id: userInformation.id, isYourProfile: false)
                        }
                    }) {
                        ProfileP(link: userInformation.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "" , size: 44, padding: 0)
                            .padding(.bottom, -28)
                        VStack(alignment: .leading, spacing: -1.5){
                            Text(userInformation.username)
                                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                                .padding(.top, 20)
                            Text(notification.content)
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .accent)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                    
                } else {
                    Image("Aicon")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: -1.5){
                        Text(  "Notice" )
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                            .padding(.top, 20)
                        Text(notification.content)
                            .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .accent)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                
            }
            .padding(.bottom, 12)
            .padding(.top, -10)
            .padding(.horizontal, 16)
            
            HStack(alignment: .bottom){
                Text(timeElapsedSince(notification.created_at, shortFormat: true))
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .cLightBrown50)
                    .padding(.bottom, -2.5)
                Spacer()
                if notification.friend_request?.request_status != nil && notification.content_type == "friend_request" {
                    if notification.friend_request!.request_status == "accepted" {
                        ButtonFeed(text: "Accepted")
                    }else{
                        ButtonFeed(text: "Accept")
                            .onTapGesture {
                                feedModel.acceptFriendRequest(api: api, id: notification.friend_request!.id) { res in
                                    switch res {
                                    case .success:
                                        feedModel.getFeedUpdated(api: api)
                                    case .failure:
                                        print("failed")
                                    }
                                }
                                
                            }
                        ButtonFeed(text: "Decline")
                            .onTapGesture {
                                feedModel.rejectFriendRequest(api: api, id: notification.friend_request!.id) { res in
                                    switch res {
                                    case .success:
                                        feedModel.getFeedUpdated(api: api)
                                    case .failure:
                                        print("failed")
                                        
                                        
                                    }
                                }
                            }
                        
                    }
                    
                } else if notification.content_type == "badge_update" {
                    ButtonFeed(text: "View Badges")
                        .onTapGesture {
                            self.tabBarSelection.selectedTab = 3
                            self.tabBarSelection.selectedBadge = notification.badge!.badge_name
                        }
                    
                } else if notification.content_type == "toilet_approved"{
                    NavigationLink(destination: DetailBathroom( bathroom: bathroom)){
                        ButtonFeed(text: "View Bathroom")
                            .onAppear{
                                feedModel.getSpecificBathroom(api: api, id: notification.toilet!.id) { res in
                                    switch res{
                                    case .success(let rsponse):
                                        bathroom = BathroomApi(id: rsponse.id, photos: rsponse.photos, name: rsponse.name, address: rsponse.address, coordinates: rsponse.coordinates, place_type: rsponse.place_type, is_for_disabled: rsponse.is_for_disabled, is_free: rsponse.is_free, is_for_babies: rsponse.is_for_babies, tags: rsponse.tags, updated_at: rsponse.updated_at)
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .task {
            if notification.content_type == "friend_request" && notification.friend_request != nil {
                api.getSpecificUser(userId: notification.friend_request!.from_user) { userRetrieve in
                    switch userRetrieve {
                    case .success(let user):
                        userInformation = user
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}


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

struct ExtraInfo: View {
    @EnvironmentObject var api: ApiManager
    @ObservedObject var mapViewModel : MapModel
    @State var bathroomInfo = BathroomApi()
    let bathroomID: String
    
    var body: some View {
        NavigationLink(destination: DetailBathroom( bathroom: BathroomApi(id: bathroomInfo.id, photos: bathroomInfo.photos, name: bathroomInfo.name, address: bathroomInfo.address, coordinates: bathroomInfo.coordinates, place_type: bathroomInfo.place_type, is_for_disabled: bathroomInfo.is_for_disabled, is_free: bathroomInfo.is_free, is_for_babies: bathroomInfo.is_for_babies, tags: bathroomInfo.tags, updated_at: bathroomInfo.updated_at))){
            HStack {
                VStack(alignment: .leading) {
                    Text(bathroomInfo.name?.capitalized ?? "Loading")
                        .normalTextStyle(fontName: "Manrope-ExtraBold", fontSize: 22, fontColor: .accent)
                        .padding(.top, -2)
                    Text(getStreet(bathroomInfo.address ?? "Loading address"))
                        .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .accent)
                }
                Spacer()
                
                CustomAsyncImage(
                    imageUrlString:  bathroomInfo.photos?.first?.photo!,
                    placeholderImageName: "noPhoto",
                    size: CGSize(width: 65, height: 65),
                    shape: .rectangle(cornerRadius: 8),
                    maxFrame: false
                )
                
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.cLightBrown)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: 85)
            .task {
                api.getSingleBathroom(id: bathroomID) { resp in
                    switch resp {
                    case .success(let responseB):
                        bathroomInfo = responseB
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
    }
}







struct ReviewsScroller: View {
    let reviews: [Review]?
    let isProfile : Bool
    let isShort : Bool
    @EnvironmentObject var mapViewModel: MapModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                if !reviews!.isEmpty {
                    if let reviews = reviews {
                        ForEach(reviews, id: \.self) { review in
                            if !review.review.isEmpty{
                                ReviewTemp(review: review, isProfile: isProfile, isShort: isShort, mapViewModel: mapViewModel)
                            }
                        }
                        if reviews.count == 1 && reviews[0].review == "" {
                            NoReviews(isProfile : isProfile)
                        }
                    }
                } else {
                    NoReviews( isProfile : isProfile)
                }
            }
            .padding(.trailing, -10)
            .scrollTargetLayout()
        }
        .contentMargins(20, for: .scrollContent)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .padding(.vertical, -20)
    }
}

struct NoReviews: View {
    let isProfile : Bool
    var body: some View {
        VStack {
            Text(!isProfile ? "Try to add some friends, \n here you will find them reviews" : "This user doesn't have any review")
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 16, fontColor: .accent)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 144)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
        .padding(.trailing, 10)
        .padding(.bottom, -6)
        
    }
}


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

import SwiftUI

struct ProfileP: View {
    let link: String
    let size: CGFloat
    let padding: CGFloat
    
    var body: some View {
        VStack {
            
            CustomAsyncImage(
                imageUrlString: link,
                placeholderImageName: "noPhoto",
                size: CGSize(width: size, height: size),
                shape: .circle,
                maxFrame: false
            )
            

        }
        .padding(.leading, padding)
    }
    
    
    
    
        
}

struct CustomAsyncImage: View {
    @EnvironmentObject var api : ApiManager
    enum ImageShape {
        case rectangle(cornerRadius: CGFloat)
        case circle
    }
    
    var imageUrlString: String?
    var placeholderImageName: String
    var size: CGSize?
    var shape: ImageShape
    var maxFrame: Bool
    
    private var imageUrl: URL? {
        if let imageUrlString = imageUrlString {
            if imageUrlString.hasPrefix("https://"){
                return URL(string: imageUrlString)
            }else if imageUrlString.hasPrefix("http://") {
                return URL(string: imageUrlString.replacingOccurrences(of: "http://", with: "https://"))
            } else {
                return URL(string: "\(api.url)\(imageUrlString)")
            }
        }
        return nil
    }
    
    var body: some View {
        Group {
            if let url = imageUrl {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        configureImage(image)
                    } else {
                        configureImage(Image(placeholderImageName))
                    }
                }
            } else {
                configureImage(Image(placeholderImageName))
            }
        }
        .applyMaxFrame(maxFrame)
        .frame(width: size?.width, height: size?.height)
    }
    
    private func configureImage(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size?.width, height: size?.height)
            .applyShape(shape)
    }
}

extension View {
    func applyMaxFrame(_ maxFrame: Bool) -> some View {
        if maxFrame {
            return self.frame(maxWidth: .infinity, maxHeight: .infinity).eraseToAnyView()
        } else {
            return self.eraseToAnyView()
        }
    }
    
    func applyShape(_ shape: CustomAsyncImage.ImageShape) -> some View {
        switch shape {
        case .rectangle(let cornerRadius):
            return self
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .eraseToAnyView()
        case .circle:
            return self
                .clipShape(Circle())
                .eraseToAnyView()
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
