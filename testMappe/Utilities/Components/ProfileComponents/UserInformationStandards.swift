import SwiftUI

struct UserInformationStandards: View {
    @EnvironmentObject var api: ApiManager
    var profilePicture : String
    let isYourProfile : Bool
    @Binding var openSheetUploadImage : Bool
    let username : String
    let friendsNumber: Int
    let id: String
    @Binding var status: RequestStatus
    @EnvironmentObject var mapViewModel: MapModel
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                ZStack {
                    ProfileP(link: profilePicture, size: 70, padding: 20)
                    if isYourProfile {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image("Edit")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 26, height: 26)
                            }
                        }
                    }
                }
                .frame(width: 70, height: 70)
                .padding(.leading, 10)
                .onTapGesture {
                    if isYourProfile{
                        openSheetUploadImage = true
                    }
                }
                VStack(alignment: .leading) {
                    Text(username.capitalized)
                        .normalTextStyle(fontName: "Manrope-Bold", fontSize: 32, fontColor: .accent)
                        .padding(.bottom, -2)
                    HStack{
                        if !isYourProfile &&  status.request_status != "pending" && status.request_status  != "accepted" {
                            VStack{
                                Text("Send Request")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .cLightBrown).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                api.sendFriendRequest(userId: id)
                                status.request_status  = "pending"
                            }
                        } else if !isYourProfile && status.request_status  != "accepted" && status.request_status  == "pending" {
                            VStack{
                                Text("Request Sent")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .white).padding(.horizontal, 10).padding(.vertical, 2)
                                
                            }
                            .background(.cLightBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            
                        } else if !isYourProfile && status.request_status  == "accepted" && status.request_status  != "pending" {
                            VStack{
                                Text("Remove Friend")
                                    .normalTextStyle(fontName: "Manrope-SemiBold", fontSize: 16, fontColor: .white).padding(.horizontal, 10).padding(.vertical, 2)
                                    .onTapGesture{
                                        api.removeFriend(userId: status.friend_request_id)
                                        status.request_status = "none"
                                    }
                                
                            }
                            .background(.cLightBrown)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }
                        
                        if friendsNumber > 0 {
                            NavigationLink(destination: UsersFriend(id: id, isYourProfile: isYourProfile, name: username)) {
                                Text("\(friendsNumber) Friends")
                                    .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                            }
                        } else {
                            Text("\(friendsNumber) Friends")
                                .normalTextStyle(fontName: "Manrope-Medium", fontSize: 16, fontColor: .accent)
                        }
                    }
                    
                }
                .padding(.leading, 16)
                
                Spacer()
            }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background(Color.white)
        .ignoresSafeArea()
        
    }
}
