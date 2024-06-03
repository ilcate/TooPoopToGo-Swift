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






struct TextFieldCustom:  View {
    @Binding var stateVariable : String
    @State var name : String
    @FocusState private var isFocused
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 18, fontColor: .accent)
                .padding(.bottom, -2)
            TextField("Insert here", text: $stateVariable)
                .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 18, fontColor: .accent)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(.capsule)
                .focused($isFocused)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .overlay(
                    Capsule()
                        .stroke(.accent, lineWidth: isFocused ? 3 : 0)
                )
        }
    }
}

struct HeaderView:  View {
    @EnvironmentObject var isTexting: IsTexting
    @ObservedObject var mapViewModel: MapModel
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
            NavigationLink(destination: ProfileView()) {
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
                                    users = us!
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
                        NavigationLink(destination: ProfileView()) {
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
    var notification : ResultFeed
    @State var userInformation = UserInfoResponse(username: "", id: "")
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                NavigationLink(destination: {
                    if userInformation.id == api.userId {
                        ProfileView()
                    } else {
                        FriendsProfileView(id: userInformation.id)
                    }
                }) {
                    
                    
                    ProfileP(link: userInformation.photo_user?.replacingOccurrences(of: "http://", with: "https://") ?? "" , size: 44, padding: 0)
                    
                    VStack(alignment: .leading, spacing: -1.5){
                        Text(userInformation.username)
                            .normalTextStyle(fontName: "Manrope-Bold", fontSize: 20, fontColor: .accent)
                        Text(notification.content)
                            .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .accent)
                    }.padding(.top, -2)
                    
                    Spacer()
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            
            HStack(alignment: .bottom){
                Text(timeElapsedSince(notification.created_at))
                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 17, fontColor: .cLightBrown50)
                    .padding(.bottom, -2.5)
                Spacer()
                if notification.content_type == "friend_request" {
                    ButtonFeed(text: "Accept")
                        .onTapGesture {
                            api.acceptFriendRequest(userId: notification.friend_request!.id)
                        }
                    ButtonFeed(text: "Decline")
                        .onTapGesture {
                            api.rejectFriendRequest(userId: notification.friend_request!.id)
                        }
                    
                }else{
                    ButtonFeed(text: "View Badge")
                    ButtonFeed(text: "Cheer")
                }
                
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .task {
            if notification.content_type == "friend_request" {
                print(notification)
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
                .normalTextStyle(fontName: "Manrope-Bold", fontSize: 17, fontColor: text == "View Badge" || text == "Decline" ? .white : .cLightBrown)
                .padding(.vertical, 5).padding(.horizontal, 8)
                .background(text == "View Badge" || text == "Decline" ? .cLightBrown50 : .accent)
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
    @State var ratingAVG = ""
    @EnvironmentObject var api : ApiManager
    
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: {
                    if review.user.id == api.userId {
                        ProfileView()
                    } else {
                        FriendsProfileView(id: review.user.id)
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
        .frame(maxWidth: .infinity, minHeight: 144, maxHeight: 144)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
        .padding(.trailing, 10)
        .padding(.bottom, -6)
        .onAppear{
            ratingAVG = getAvg(review: review)
            
            print(api.userId)
        }
    }
    
}







struct ReviewsScroller: View {
    let reviews: [Review]?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                if !reviews!.isEmpty {
                    if let reviews = reviews {
                        ForEach(reviews, id: \.self) { review in
                            if !review.review.isEmpty{
                                ReviewTemp(review: review)
                            }
                        }
                        if reviews.count == 1 && reviews[0].review == "" {
                            NoReviews()
                        }
                    }
                } else {
                    NoReviews()
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
    var body: some View {
        VStack {
            Text("This place has no comments or reviews. \n Add the first one!")
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


struct ProfileP :View {
    let link : String
    let size : CGFloat
    let padding : CGFloat
    
    var body: some View {
        VStack{
            if let photoURL = URL(string: link) {
                AsyncImage(url: photoURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    default:
                        Image("noPhoto")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                        
                    }
                }
            } else {
                Image("noPhoto")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
            }
        }
        .frame(width: size, height: size)
        .padding(.leading, padding)
    }
}
