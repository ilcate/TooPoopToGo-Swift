import SwiftUI
import Alamofire

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var api: ApiManager
    @StateObject var profileModel = ProfileModel()
    @State var status = "none"
    
    var body: some View {
        ZStack {
            VStack {
                UserInformationStandards(profilePicture: profileModel.userInfo.photo_user!, isYourProfile: true, openSheetUploadImage: $profileModel.openSheetUploadImage, username: profileModel.userInfo.username, friendsNumber: profileModel.userInfo.friends_number ?? 0, id: profileModel.userInfo.id, status: $status)
                OtherInformationUser()
                Spacer()
            }
            HeaderProfile(screenName: "Profile", name: profileModel.userInfo.username)
            .task {
                profileModel.getProfile(api: api)
            }
            .navigationBarBackButtonHidden(true)
        }
        .background(Color.cLightBrown)
        .sheet(isPresented: $profileModel.openSheetUploadImage, onDismiss: {
            profileModel.openSheetUploadImage = false
            if !profileModel.imagesNewAnnotation.isEmpty {
                api.uploadProfilePicture(image: profileModel.imagesNewAnnotation[0], userId: profileModel.userInfo.id) { result in
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
                AddImageSheet(photosPickerItems: $profileModel.photosPikerItems, imagesNewAnnotation: $profileModel.imagesNewAnnotation, isMaxFivePhotos: false)
                    .presentationDetents([.fraction(0.26)])
                    .presentationCornerRadius(18)
            }
        }
    }
}
