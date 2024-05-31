import Foundation
import SwiftUI
import Alamofire
import PhotosUI


final class ProfileModel: ObservableObject{
    @Published var userInfo = UserInfoResponse(username: "Loading...", photo_user: "", id: "", friends_number: 0, badges: [], used_toilets: [])
    @Published var openSheetUploadImage = false
    @Published var photosPikerItems: [PhotosPickerItem] = []
    @Published var imagesNewAnnotation : [UIImage] = []
    
    func updateUserInfo(newUserInfo: UserInfoResponse) {
            DispatchQueue.main.async {
                self.userInfo = UserInfoResponse(username: newUserInfo.username, photo_user: newUserInfo.photo_user!.replacingOccurrences(of: "http://", with: "https://"), id: newUserInfo.id, friends_number: newUserInfo.friends_number, badges: newUserInfo.badges, used_toilets: newUserInfo.used_toilets)
            }
        }
    
    func getProfile(api: ApiManager) {
        api.getUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfoResponse):
                    if var photoUser = userInfoResponse.photo_user {
                        photoUser = photoUser.replacingOccurrences(of: "http://", with: "https://")
                        self.userInfo = UserInfoResponse(username: userInfoResponse.username, photo_user: photoUser, id: userInfoResponse.id, friends_number: userInfoResponse.friends_number, badges: userInfoResponse.badges, used_toilets: userInfoResponse.used_toilets)
                    } else {
                        self.userInfo = UserInfoResponse(username: userInfoResponse.username, photo_user: nil, id: userInfoResponse.id, friends_number: userInfoResponse.friends_number, badges: userInfoResponse.badges, used_toilets: userInfoResponse.used_toilets)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    

}
