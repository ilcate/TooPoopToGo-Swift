import SwiftUI
import Alamofire

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    @State var id: String? = nil
    @State var userSelected = UserInfoResponse(username: "Loading...", photo_user: "", id: "" , friends_number: 0, badges: [""])
    @State var status = RequestStatus(request_status: "none", friend_request_id: "")
    @StateObject var profileModel = ProfileModel()

    @State var isYourProfile: Bool

    var body: some View {
        ZStack {
            VStack {
                UserInformationStandards(profilePicture: (isYourProfile ? profileModel.userInfo.photo_user! : userSelected.photo_user!).replacingOccurrences(of: "http://", with: "https://"), isYourProfile: isYourProfile, openSheetUploadImage: $profileModel.openSheetUploadImage, username: isYourProfile ? profileModel.userInfo.username : userSelected.username, friendsNumber: isYourProfile ? (profileModel.userInfo.friends_number ?? 0) : userSelected.friends_number!, id: isYourProfile ? profileModel.userInfo.id : userSelected.id, status: $status)
                OtherInformationUser(profileModel: profileModel,  isYourself: isYourProfile, userId: isYourProfile ? profileModel.userInfo.id : userSelected.id)
                Spacer()
            }
            HeaderProfile(screenName: "Profile", name: isYourProfile ? profileModel.userInfo.username : userSelected.username)
        }
        .background(Color.cLightBrown)
        .task {
            print(isYourProfile)
            if isYourProfile {
                profileModel.getProfile(api: api)
            } else {
                api.getSpecificUser(userId: id!) { resp in
                    switch resp {
                    case .success(let info):
                        userSelected = UserInfoResponse(username: info.username, photo_user: info.photo_user, id: info.id, friends_number: info.friends_number, badges: info.badges)
                        profileModel.userInfo.id = userSelected.id
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                api.statusFriendRequest(userId: id!) { result in
                    switch result {
                    case .success(let friendStatus):
                        status = RequestStatus(request_status: friendStatus.request_status, friend_request_id: friendStatus.friend_request_id)
                    case .failure:
                        status = RequestStatus(request_status: "none", friend_request_id: "")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $profileModel.openSheetUploadImage, onDismiss: {
            profileModel.openSheetUploadImage = false
            if !profileModel.imagesNewAnnotation.isEmpty {
                api.uploadProfilePicture(image: profileModel.imagesNewAnnotation[0]) { result in
                    switch result {
                    case .success(let resp):
                        profileModel.updateUserInfo(newUserInfo: resp)
                        profileModel.imagesNewAnnotation.removeAll()
                    case .failure(let error):
                        print("Failed to upload profile picture: \(error)")
                    }
                }
            }
        }) {
            ZStack {
                Color.cLightBrown.ignoresSafeArea(.all)
                AddImageSheet(
                    photosPickerItems: $profileModel.photosPikerItems,
                    imagesNewAnnotation: $profileModel.imagesNewAnnotation,
                    isMaxFivePhotos: false
                )
                .presentationDetents([.fraction(0.26)])
                .presentationCornerRadius(18)
            }
        }
    }
}
